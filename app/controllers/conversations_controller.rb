class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[index]

  def index
    @conversations = Match
                     .involving(@profile)
                     .joins(:messages)
                     .includes(:profile_1, :profile_2)
                     .select(
                       "matches.*",
                       "COUNT(messages.id) AS messages_count",
                       "MAX(messages.created_at) AS last_message_at"
                     )
                     .group("matches.id")
                     .order(Arel.sql("MAX(messages.created_at) DESC"))
  end

  private

  def set_profile
    @profile = current_user.profile
    redirect_to new_profile_path unless @profile
  end
end