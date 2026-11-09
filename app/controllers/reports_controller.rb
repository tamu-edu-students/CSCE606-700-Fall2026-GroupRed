class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_person, only: %i[ new create ]

  def index
    @reports = policy_scope(Report).where(reporter: current_user).includes(:reportable).order(created_at: :desc)
  end

  def new
    @report = current_user.reports.new(reportable: @person)
    authorize @report
  end

  def create
    @report = current_user.reports.new(reportable: @person, reason: params.dig(:report, :reason))
    authorize @report

    if @report.save
      redirect_to reports_path, notice: "Thanks. Your report about #{@person.display_name} was sent to our moderators."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  # Same rules as viewing a profile: must exist, have a profile, not be you, not be blocked
  def load_person
    @person = User.includes(:profile).find_by(id: params[:person_id])
    return redirect_to profile_path if @person == current_user

    if @person&.profile.nil? || current_user.blocked_with?(@person)
      redirect_to root_path, alert: PeopleController::NOT_AVAILABLE
    end
  end
end
