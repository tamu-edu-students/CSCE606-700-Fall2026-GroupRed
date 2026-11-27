require "rails_helper"

RSpec.describe "Messages", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user, display_name: "Sam") }
  let(:other_profile) { create(:profile, display_name: "Taylor") }
  let!(:our_match) { create(:match, profile_1: profile, profile_2: other_profile) }

  def send_message(body, to: our_match)
    post match_messages_path(to), params: { body: body }
  end

  context "when not signed in" do
    it "sends them to sign in" do
      send_message("Hi")

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when signed in" do
    before { sign_in user }

    describe "GET /matches/:id" do
      it "shows both people's messages oldest to newest with who sent them" do
        create(:message, match: our_match, sender: other_profile, body: "Hey Sam!", created_at: 2.minutes.ago)
        create(:message, match: our_match, sender: profile, body: "Hey Taylor!", created_at: 1.minute.ago)

        get match_path(our_match)

        expect(response).to have_http_status(:success)
        expect(response.body).to match(/Taylor:.*Hey Sam!.*You:.*Hey Taylor!/m)
      end

      it "marks incoming unread messages as seen" do
        incoming = create(:message, match: our_match, sender: other_profile, seen: false)
        outgoing = create(:message, match: our_match, sender: profile, seen: false)

        get match_path(our_match)

        expect(incoming.reload).to be_seen
        expect(outgoing.reload).not_to be_seen
        expect(response.headers["Cache-Control"]).to include("no-store")
        expect(response.body).not_to include('class="notification-count">')
      end

      it "marks incoming unread messages as seen for the person stored as profile_2" do
        incoming = create(:message, match: our_match, sender: profile, seen: false)
        outgoing = create(:message, match: our_match, sender: other_profile, seen: false)
        sign_in other_profile.user

        get match_path(our_match)

        expect(incoming.reload).to be_seen
        expect(outgoing.reload).not_to be_seen
      end

      it "works for the person stored as profile_2" do
        sign_in other_profile.user

        get match_path(our_match)

        expect(response.body).to include("Messages with Sam")
      end

      it "sends someone outside the match to not authorized" do
        get match_path(create(:match))

        expect(response).to redirect_to(matches_path)
        expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
      end

      it "sends a blocked user to not authorized" do
        other_profile.user.blocks.create!(blocked: user)

        get match_path(our_match)

        expect(response).to redirect_to(matches_path)
        expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
      end

      it "hides a conversation when this user blocked the other user" do
        user.blocks.create!(blocked: other_profile.user)

        get match_path(our_match)

        expect(response).to redirect_to(matches_path)
        expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
      end

      it "hides a conversation with a suspended match" do
        other_profile.user.update!(suspended_at: Time.current)

        get match_path(our_match)

        expect(response).to redirect_to(matches_path)
        expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
      end

      it "handles a match that doesn't exist" do
        get match_path(id: 0)

        expect(response).to redirect_to(matches_path)
        expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
      end

      it "sends a user without a profile to create one" do
        sign_in create(:user)

        get match_path(our_match)

        expect(response).to redirect_to(new_profile_path)
      end
    end

    describe "POST /matches/:match_id/messages" do
      it "saves the message and returns to the message form" do
        expect { send_message("Hi Taylor!") }.to change(our_match.messages, :count).by(1)

        expect(response).to redirect_to(
          match_path(our_match, anchor: "message-form")
        )
        expect(our_match.messages.last).to have_attributes(
          sender: profile, body: "Hi Taylor!"
        )

        follow_redirect!
        form = Nokogiri::HTML(response.body).at_css("form#message-form")
        expect(form).to be_present
        expect(form.at_css("textarea[name='body']").text).to be_blank
      end

      it "rejects a blank message and shows the error once beside the message box" do
        expect { send_message("   ") }.not_to change(Message, :count)

        expect(response).to redirect_to(
          match_path(our_match, anchor: "message-form")
        )
        expect(flash[:alert]).to eq("Message can't be blank")

        follow_redirect!
        document = Nokogiri::HTML(response.body)

        expect(document.css("[role='alert']").size).to eq(1)

        error = document.at_css("form#message-form [role='alert']")
        expect(error).to be_present
        expect(error.text).to eq("Message can't be blank")
      end

      it "doesn't let a user message someone they blocked" do
        user.blocks.create!(blocked: other_profile.user)

        expect { send_message("Hi") }.not_to change(Message, :count)
        expect(response).to redirect_to(matches_path)
        expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
      end

      it "doesn't let a user message someone who blocked them" do
        other_profile.user.blocks.create!(blocked: user)

        expect { send_message("Hi") }.not_to change(Message, :count)
        expect(response).to redirect_to(matches_path)
        expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
      end

      it "doesn't let a user post into someone else's match" do
        expect { send_message("Hi", to: create(:match)) }.not_to change(Message, :count)
        expect(response).to redirect_to(matches_path)
        expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
      end
    end
    describe "GET /matches/:match_id/messages/:id/confirm_destroy" do
      it "links Delete to a confirmation page instead of deleting right away" do
        message = create(:message, match: our_match, sender: profile, body: "Oops")

        get match_path(our_match)

        expect(response.body).to include(%(href="#{confirm_destroy_match_message_path(our_match, message)}"))
        expect(response.body).not_to include("turbo-confirm")
      end

      it "shows the message and a warning without deleting it" do
        message = create(:message, match: our_match, sender: profile, body: "Oops")

        get confirm_destroy_match_message_path(our_match, message)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Oops")
        expect(response.body).to include("This will delete the message for both you and Taylor.")
        expect(response.body).to include(%(href="#{match_path(our_match)}"))
        expect(Message.exists?(message.id)).to be(true)
      end

      it "won't confirm deleting the other person's message" do
        message = create(:message, match: our_match, sender: other_profile)

        get confirm_destroy_match_message_path(our_match, message)

        expect(response).to redirect_to(match_path(our_match))
        expect(flash[:alert]).to eq("You can only delete your own messages.")
      end

      it "won't show a message from someone else's conversation" do
        stranger_match = create(:match, profile_1: create(:profile), profile_2: create(:profile))
        message = create(:message, match: stranger_match, body: "Private")

        get confirm_destroy_match_message_path(stranger_match, message)

        expect(response).to redirect_to(matches_path)
        expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
      end
    end

    describe "DELETE /matches/:match_id/messages/:id" do
      it "deletes my own message" do
        message = create(:message, match: our_match, sender: profile, body: "Oops")

        expect { delete match_message_path(our_match, message) }.to change(Message, :count).by(-1)
        expect(flash[:notice]).to eq("Message deleted.")
      end

      it "won't delete the other person's message" do
        message = create(:message, match: our_match, sender: other_profile)

        expect { delete match_message_path(our_match, message) }.not_to change(Message, :count)
        expect(flash[:alert]).to eq("You can only delete your own messages.")
      end

      it "won't delete in someone else's conversation" do
        stranger_match = create(:match, profile_1: create(:profile), profile_2: create(:profile))
        message = create(:message, match: stranger_match)

        expect { delete match_message_path(stranger_match, message) }.not_to change(Message, :count)
        expect(response).to redirect_to(matches_path)
        expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
      end
    end
  end
end
