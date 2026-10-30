class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  def index
    @matches = Match.where("profile_1_id = ? OR profile_2_id = ?", @profile.id, @profile.id)
  end

  private
  def set_profile
    @profile = current_user.profile
    redirect_to new_profile_path unless @profile
  end
end
