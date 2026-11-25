class OpenersController < ApplicationController
  include MatchConversation

  before_action :authenticate_user!
  before_action :require_profile
  before_action :set_match

  def create
    companion = current_user.companion || current_user.create_companion!

    if companion.out_of_messages_today?
      return redirect_to match_path(@match, anchor: "message-form"),
                         alert: "#{companion.name} needs a break. Chat again tomorrow!"
    end

    openers = CompanionService.openers(companion, @other_profile)

    if openers.any?
      session[:opener_ideas] = { "match_id" => @match.id, "ideas" => openers }
      redirect_to match_path(@match, anchor: "message-form")
    else
      redirect_to match_path(@match, anchor: "message-form"),
                  alert: CompanionService::FALLBACK
    end
  end
end
