class ReplySuggestionsController < ApplicationController
  include MatchConversation

  before_action :authenticate_user!
  before_action :require_profile
  before_action :set_match

  def create
    companion = current_user.companion || current_user.create_companion!

    if companion.out_of_messages_today?
      return redirect_to match_path(@match), alert: "#{companion.name} needs a break. Chat again tomorrow!"
    end

    suggestion = CompanionService.suggest_reply(companion, @match, @profile)

    if suggestion.present?
      redirect_to match_path(@match, draft: suggestion),
                  notice: "Reply suggestion added. You can edit it before sending."
    else
      redirect_to match_path(@match), alert: CompanionService::FALLBACK
    end
  end
end
