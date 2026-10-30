class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  def index
    @matches = Match.joins(profile_1: :user, profile_2: :user)
                    .where("profile_1_id = :id OR profile_2_id = :id", id: @profile.id)
                    .where(
                      profile_1: {
                        users: { id: User.not_blocked_with(current_user).select(:id) }
                      }
                    )
                    .where(
                      profile_2: {
                        users: { id: User.not_blocked_with(current_user).select(:id) }
                      }
                    )
  end

  private
  def set_profile
    @profile = current_user.profile
    redirect_to new_profile_path unless @profile
  end
end
