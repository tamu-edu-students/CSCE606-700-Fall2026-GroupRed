class MatchesController < ApplicationController
  def index
    @matches = Match.where("profile_1_id = ? OR profile_2_id = ?", current_user.profile.id, current_user.profile.id)
  end
end
