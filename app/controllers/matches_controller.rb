class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  def index
    visible_profile_ids = Profile
      .where(user_id: User.not_blocked_with(current_user).select(:id))
      .select(:id)

    @matches = Match
      .where("profile_1_id = :id OR profile_2_id = :id", id: @profile.id)
      .where(profile_1_id: visible_profile_ids)
      .where(profile_2_id: visible_profile_ids)
  end

  private
  def set_profile
    @profile = current_user.profile
    redirect_to new_profile_path unless @profile
  end
end
