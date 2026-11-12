module MatchConversation
  extend ActiveSupport::Concern

  NOT_AVAILABLE = "That conversation isn't available.".freeze

  private

  def require_profile
    @profile = current_user.profile
    redirect_to new_profile_path unless @profile
  end

  # Only the two people in a match can open it, and a block either way closes it => match policy decides
  def set_match
    @match = Match.includes(profile_1: :user, profile_2: :user).find_by(id: params[:match_id] || params[:id])
    return redirect_to(matches_path, alert: NOT_AVAILABLE) unless @match

    authorize @match, policy_class: MessagePolicy
    @other_profile = @match.other_profile(@profile)
  end
end
