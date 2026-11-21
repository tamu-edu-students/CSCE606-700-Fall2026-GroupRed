class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[index]

  def index
    response.headers["Cache-Control"] = "no-store"

    @conversations = Match
                     .involving(@profile)
                     .joins(:messages)
                     .includes(:profile_1, :profile_2)
                     .select(
                       "matches.*",
                       "COUNT(messages.id) AS messages_count",
                       "SUM(CASE WHEN NOT messages.seen AND messages.sender_id != #{@profile.id} THEN 1 ELSE 0 END) AS unread_messages_count",
                       "MAX(messages.created_at) AS last_message_at"
                     )
                     .group("matches.id")
                     .order(Arel.sql("MAX(messages.created_at) DESC"))
                     .not_blocked_with(@profile)
                     .not_suspended_with(@profile)
  end

  private

  def set_profile
    @profile = current_user.profile
    redirect_to new_profile_path unless @profile
  end
end