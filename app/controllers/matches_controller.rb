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
      .includes(
        profile_1: [ :user, { photo_attachment: :blob } ],
        profile_2: [ :user, { photo_attachment: :blob } ]
      )
  end

  # The conversation with one match. New messages show after sending or refreshing (ADR 0002).
  def show
    response.headers["Cache-Control"] = "no-store"

    @messages = @match.messages.oldest_first.includes(:sender)
    saved_ideas = session[:opener_ideas] || {}
    @openers = saved_ideas["match_id"] == @match.id ? Array(saved_ideas["ideas"]) : []
    @draft = params[:draft].to_s.truncate(Message::MAX_LENGTH)
    mark_messages_as_seen
    set_unread_message_count
  end

  # Confirmation page, so the warning shows even without JavaScript (ADR 0002).
  def unmatch
  end

  def destroy
    Swipe.find_by(swiper: @profile, prospect: @other_profile)&.update!(liked: false)
    @match.destroy!
    redirect_to matches_path, notice: "You unmatched with #{@other_profile.display_name}."
  end

  private

  def mark_messages_as_seen
    @match.messages
      .where(seen: false, sender_id: @other_profile.id)
      .update_all(seen: true)
  end
end
