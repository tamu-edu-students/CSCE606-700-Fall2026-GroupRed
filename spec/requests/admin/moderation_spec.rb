require "rails_helper"

RSpec.describe "Admin moderation", type: :request do
  let(:admin) { create(:user, role: "admin") }
  let(:sam) { create(:user) }
  let(:alex) { create(:user) }
  let!(:report) { create(:report, reporter: sam, reportable: alex) }

  context "as an admin" do
    before { sign_in admin }

    it "lists open reports" do
      get admin_path
      expect(response.body).to include("Sent rude messages.")
    end

    it "bans the reported person and resolves their open reports" do
      other_report = create(:report, reportable: alex)
      patch ban_admin_report_path(report)

      expect(alex.reload).to be_suspended
      expect(report.reload.status).to eq("resolved")
      expect(other_report.reload.status).to eq("resolved")
      expect(response).to redirect_to(admin_path)
    end

    it "won't ban based on a report that isn't about a person" do
      companion_report = Report.create!(reporter: sam, reportable: alex.companion, reason: "Rude reply.")
      patch ban_admin_report_path(companion_report)

      expect(flash[:alert]).to eq("Only reports about a person can lead to a ban.")
      expect(alex.reload).not_to be_suspended
    end

    it "won't ban an admin" do
      admin_report = create(:report, reporter: sam, reportable: create(:user, role: "admin"))
      patch ban_admin_report_path(admin_report)

      expect(flash[:alert]).to eq("Admins can't be banned.")
    end

    it "dismisses a report without banning anyone" do
      patch dismiss_admin_report_path(report)

      expect(report.reload.status).to eq("dismissed")
      expect(alex.reload).not_to be_suspended
    end

    it "pardons a banned person" do
      alex.update!(suspended_at: Time.current)
      patch pardon_admin_user_path(alex)

      expect(alex.reload).not_to be_suspended
    end

    it "handles a report that no longer exists" do
      patch ban_admin_report_path(id: 0)
      expect(flash[:alert]).to eq("That report isn't available.")
    end

    it "handles an account that no longer exists" do
      patch pardon_admin_user_path(id: 0)
      expect(flash[:alert]).to eq("That account isn't available.")
    end
  end

  context "as a regular user" do
    before { sign_in sam }

    it "can't ban anyone" do
      patch ban_admin_report_path(report)

      expect(response).to redirect_to(not_authorized_path)
      expect(alex.reload).not_to be_suspended
    end

    it "can't pardon anyone" do
      alex.update!(suspended_at: Time.current)
      patch pardon_admin_user_path(alex)

      expect(response).to redirect_to(not_authorized_path)
      expect(alex.reload).to be_suspended
    end
  end
end
