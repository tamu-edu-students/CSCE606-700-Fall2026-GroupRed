require "rails_helper"

RSpec.describe "Profile feedback", type: :request do
  let(:user) { create(:user) }
  let(:companion) { user.companion }

  context "when not signed in" do
    it "sends the visitor to sign in" do
      post profile_feedback_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when signed in" do
    before { sign_in user }

    it "asks me to make a profile first" do
      expect(CompanionService).not_to receive(:ask)
      post profile_feedback_path
      expect(response).to redirect_to(new_profile_path)
    end

    context "with a profile" do
      let!(:profile) { create(:profile, user: user) }

      it "shows a button to ask the companion" do
        get profile_path
        expect(response.body).to include("What Wingman thinks", "What do you think?")
      end

      it "shows the tips on my profile" do
        allow(CompanionService).to receive(:ask).and_return("Say where you like to hike.")
        post profile_feedback_path
        expect(response).to redirect_to(profile_path)

        follow_redirect!
        expect(response.body).to include("Say where you like to hike.")
      end

      it "shows the newest tips after asking again" do
        allow(CompanionService).to receive(:ask).and_return("Old tip", "New tip")
        2.times { post profile_feedback_path }

        get profile_path
        expect(response.body).to include("New tip")
        expect(response.body).not_to include("Old tip")
      end

      it "explains when the companion is unavailable" do
        allow(CompanionService).to receive(:ask).and_return(nil)
        post profile_feedback_path
        expect(flash[:alert]).to eq(CompanionService::FALLBACK)
        expect(CompanionMessage.count).to eq(0)
      end

      it "stops at the daily limit" do
        Companion::DAILY_MESSAGE_LIMIT.times do
          companion.companion_messages.create!(profile: profile, role: "user", body: "Hi")
        end
        expect(CompanionService).not_to receive(:ask)

        post profile_feedback_path
        expect(flash[:alert]).to eq("Wingman needs a break. Chat again tomorrow!")
      end
    end
  end
end
