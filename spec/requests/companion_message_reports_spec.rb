require "rails_helper"

RSpec.describe "Reporting a companion reply", type: :request do
  let(:sam) { create(:user) }
  let(:taylor) { create(:user) }
  let(:profile) { taylor.create_profile!(display_name: "Taylor") }
  let(:reply) { sam.companion.companion_messages.create!(profile: profile, role: "companion", body: "Yikes, hard pass.") }

  context "when signed in" do
    before { sign_in sam }

    it "files a report that quotes the reply" do
      expect { post companion_message_reports_path(reply) }.to change(Report, :count).by(1)

      report = Report.last
      expect(report.reportable).to eq(reply)
      expect(report.reason).to include("Yikes, hard pass.")
      expect(response).to redirect_to(swipes_path)
    end

    it "doesn't file the same report twice" do
      post companion_message_reports_path(reply)
      expect { post companion_message_reports_path(reply) }.not_to change(Report, :count)
      expect(flash[:notice]).to eq("You already reported that reply.")
    end

    it "won't report my own message to the companion" do
      mine = sam.companion.companion_messages.create!(profile: profile, role: "user", body: "Should I like her?")
      post companion_message_reports_path(mine)

      expect(flash[:alert]).to eq("That reply isn't available.")
    end

    it "won't report a reply from someone else's companion" do
      others = taylor.companion.companion_messages.create!(profile: profile, role: "companion", body: "Nice!")
      post companion_message_reports_path(others)

      expect(flash[:alert]).to eq("That reply isn't available.")
    end
  end

  it "requires signing in" do
    post companion_message_reports_path(reply)
    expect(response).to redirect_to(new_user_session_path)
  end
end
