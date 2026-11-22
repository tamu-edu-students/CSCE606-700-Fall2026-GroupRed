require "rails_helper"

RSpec.describe "Message reports", type: :request do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user, display_name: "Sam") }
  let(:other_profile) { create(:profile, display_name: "Taylor") }
  let!(:our_match) { create(:match, profile_1: profile, profile_2: other_profile) }
  let!(:their_message) { create(:message, match: our_match, sender: other_profile, body: "Rude message") }
  let!(:my_message) { create(:message, match: our_match, sender: profile, body: "Hi Taylor") }

  def report(message, match: our_match)
    post match_message_report_path(match, message)
  end

  it "requires signing in" do
    report(their_message)
    expect(response).to redirect_to(new_user_session_path)
  end

  context "when signed in" do
    before { sign_in user }

    it "reports the sender with the message quoted" do
      expect { report(their_message) }.to change(Report, :count).by(1)

      saved = Report.last
      expect(saved.reporter).to eq(user)
      expect(saved.reportable).to eq(other_profile.user)
      expect(saved.reason).to include("Rude message")
      expect(flash[:notice]).to eq("Thanks. We'll review that message.")
    end

    it "doesn't report the same message twice" do
      report(their_message)

      expect { report(their_message) }.not_to change(Report, :count)
      expect(flash[:notice]).to eq("You already reported that message.")
    end

    it "won't report my own message" do
      expect { report(my_message) }.not_to change(Report, :count)
      expect(flash[:alert]).to eq("That message can't be reported.")
    end

    it "won't report a message from someone else's conversation" do
      stranger_match = create(:match, profile_1: create(:profile), profile_2: create(:profile))
      stranger_message = create(:message, match: stranger_match)

      expect { report(stranger_message, match: stranger_match) }.not_to change(Report, :count)
      expect(response).to redirect_to(matches_path)
      expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
    end
  end
end
