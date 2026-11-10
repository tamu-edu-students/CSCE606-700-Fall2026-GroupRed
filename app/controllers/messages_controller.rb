class MessagesController < ApplicationController
  include MatchConversation

  before_action :authenticate_user!
  before_action :require_profile
  before_action :set_match

  def create
    message = @match.messages.new(sender: @profile, body: params[:body].to_s)

    if message.save
      redirect_to match_path(@match)
    else
      redirect_to match_path(@match), alert: message.errors.full_messages.to_sentence
    end
  end
end
