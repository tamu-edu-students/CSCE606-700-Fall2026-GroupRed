class AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :admin, :show?
    @users = User.includes(:profile)

    if params[:search].present?
      @users = @users.joins(:profile).where("profiles.display_name ILIKE ?", "%#{params[:search]}%")
    end

    @users = @users.order(:created_at)

    @open_reports = policy_scope(Report).open.includes(reporter: :profile).includes(:reportable).order(:created_at)
    @suspended_users = User.where.not(suspended_at: nil).includes(:profile).order(suspended_at: :desc)
  end
end
