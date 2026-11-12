class OpenersController < ApplicationController
  include MatchConversation

  before_action :authenticate_user!
  before_action :require_profile
  before_action :set_match

  def create
    companion = current_user.companion || current_user.create_companion!
    if companion.out_of_messages_today?
      return redirect_to match_path(@match), alert: "#{companion.name} needs a break. Chat again tomorrow!"
    end

    openers = CompanionService.openers(companion, @other_profile)
    if openers.any?
      flash[:openers] = openers
      redirect_to match_path(@match)
    else
      redirect_to match_path(@match), alert: CompanionService::FALLBACK
    end
  end
end
