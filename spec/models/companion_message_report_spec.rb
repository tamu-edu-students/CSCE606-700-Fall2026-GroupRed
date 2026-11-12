require "rails_helper"

RSpec.describe CompanionMessage, "reports", type: :model do
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let(:profile) { other.create_profile!(display_name: "Taylor") }
  let(:message) { user.companion.companion_messages.create!(profile: profile, role: "companion", body: "Yikes, hard pass.") }

  it "is named after the companion on reports" do
    expect(message.display_name).to eq("Wingman's reply")
  end

  it "deletes its reports when the reply is deleted" do
    Report.create!(reporter: user, reportable: message, reason: "Mean reply.")
    expect { message.destroy }.to change(Report, :count).by(-1)
  end
end
