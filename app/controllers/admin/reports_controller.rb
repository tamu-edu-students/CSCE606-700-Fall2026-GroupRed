module Admin
  class ReportsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_report

    # Bans the reported person and closes every open report about them
    def ban
      person = @report.reportable
      return redirect_to(admin_path, alert: "Only reports about a person can lead to a ban.") unless person.is_a?(User)
      return redirect_to(admin_path, alert: "Admins can't be banned.") if person.admin?

      Report.transaction do
        person.update!(suspended_at: Time.current)
        Report.open.where(reportable: person).update_all(status: "resolved", updated_at: Time.current)
      end

      redirect_to admin_path, notice: "#{person.display_name} is banned."
    end

    def dismiss
      @report.update!(status: "dismissed")
      redirect_to admin_path, notice: "Report dismissed."
    end

    private

    def set_report
      authorize :admin, :show?
      @report = Report.find_by(id: params[:id])
      return redirect_to(admin_path, alert: "That report isn't available.") unless @report

      authorize @report, :moderate?
    end
  end
end
