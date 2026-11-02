class PeopleController < ApplicationController
  NOT_AVAILABLE = "That profile isn't available.".freeze

  before_action :authenticate_user!

  def show
    @person = User.includes(:profile).find_by(id: params[:id])
    return redirect_to profile_path if @person == current_user

    # Same message for missing and blocked profiles
    if @person&.profile.nil? || current_user.blocked_with?(@person)
      redirect_to root_path, alert: NOT_AVAILABLE
    end
  end
end
