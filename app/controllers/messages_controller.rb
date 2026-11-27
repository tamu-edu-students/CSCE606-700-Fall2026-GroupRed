class MessagesController < ApplicationController
  include MatchConversation

  ONLY_OWN_MESSAGES = "You can only delete your own messages.".freeze

  before_action :authenticate_user!
  before_action :require_profile
  before_action :set_match

  def create
    message = @match.messages.new(sender: @profile, body: params[:body].to_s)

    if message.save
      session.delete(:opener_ideas) if session.dig(:opener_ideas, "match_id") == @match.id
      redirect_to match_path(@match, anchor: "message-form")
    else
      redirect_to match_path(@match, anchor: "message-form"),
                  alert: message.errors.full_messages.to_sentence
    end
  end

  # Confirmation page, so the warning shows even without JavaScript (ADR 0002).
  def confirm_destroy
    @message = own_message
    redirect_to(match_path(@match), alert: ONLY_OWN_MESSAGES) unless @message
  end

  def destroy
    message = own_message
    return redirect_to(match_path(@match), alert: ONLY_OWN_MESSAGES) unless message

    message.destroy!
    redirect_to match_path(@match), notice: "Message deleted."
  end

  private

  def own_message
    @match.messages.find_by(id: params[:id], sender: @profile)
  end
end
