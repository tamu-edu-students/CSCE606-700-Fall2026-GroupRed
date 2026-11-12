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

      it "works for the person stored as profile_2" do
        sign_in other_profile.user

        get match_path(our_match)

        expect(response.body).to include("Messages with Sam")
      end

      it "sends someone outside the match to not authorized" do
        get match_path(create(:match))

        expect(response).to redirect_to(not_authorized_path)
      end

      it "sends a blocked user to not authorized" do
        other_profile.user.blocks.create!(blocked: user)

        get match_path(our_match)

        expect(response).to redirect_to(not_authorized_path)
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
      it "saves the message and goes back to the conversation" do
        expect { send_message("Hi Taylor!") }.to change(our_match.messages, :count).by(1)

        expect(response).to redirect_to(match_path(our_match))
        expect(our_match.messages.last).to have_attributes(sender: profile, body: "Hi Taylor!")
      end

      it "doesn't save a blank message and shows an error" do
        expect { send_message("   ") }.not_to change(Message, :count)

        expect(response).to redirect_to(match_path(our_match))
        expect(flash[:alert]).to eq("Message can't be blank")
      end

      it "doesn't let a user message someone they blocked" do
        user.blocks.create!(blocked: other_profile.user)

        expect { send_message("Hi") }.not_to change(Message, :count)
        expect(response).to redirect_to(not_authorized_path)
      end

      it "doesn't let a user message someone who blocked them" do
        other_profile.user.blocks.create!(blocked: user)

        expect { send_message("Hi") }.not_to change(Message, :count)
        expect(response).to redirect_to(not_authorized_path)
      end

      it "doesn't let a user post into someone else's match" do
        expect { send_message("Hi", to: create(:match)) }.not_to change(Message, :count)
        expect(response).to redirect_to(not_authorized_path)
      end
    end
  end
end
