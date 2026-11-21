class MatchesController < ApplicationController
  include MatchConversation

  before_action :authenticate_user!
  before_action :require_profile
  before_action :set_match, only: %i[ show unmatch destroy ]

  def index
    visible_profile_ids = Profile
      .where(user_id: User.not_blocked_with(current_user).where(suspended_at: nil).select(:id))
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
    @openers = Array(flash[:openers])
    @draft = params[:draft].to_s.truncate(Message::MAX_LENGTH)
  end

  # Confirmation page, so the warning shows even without JavaScript (ADR 0002).
  def unmatch
  end

  def destroy
    Swipe.find_by(swiper: @profile, prospect: @other_profile)&.update!(liked: false)
    @match.destroy!
    redirect_to matches_path, notice: "You unmatched with #{@other_profile.display_name}."
  end
end
