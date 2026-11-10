class MatchesController < ApplicationController
  include MatchConversation

  before_action :authenticate_user!
  before_action :require_profile
  before_action :set_match, only: :show

  def index
    visible_profile_ids = Profile
      .where(user_id: User.not_blocked_with(current_user).select(:id))
      .select(:id)

    @matches = Match
      .involving(@profile)
      .where(profile_1_id: visible_profile_ids)
      .where(profile_2_id: visible_profile_ids)
      .includes(:profile_1, :profile_2)
  end

  # The conversation with one match. New messages show after sending or refreshing (ADR 0002).
  def show
    @messages = @match.messages.oldest_first.includes(:sender)
  end
end
