class ProfileFeedbacksController < ApplicationController
  before_action :authenticate_user!

  def create
    profile = current_user.profile
    return redirect_to new_profile_path unless profile

    companion = current_user.companion || current_user.create_companion!
    if companion.out_of_messages_today?
      return redirect_to profile_path, alert: "#{companion.name} needs a break. Chat again tomorrow!"
    end

    if CompanionService.profile_feedback(companion, profile)
      redirect_to profile_path
    else
      redirect_to profile_path, alert: CompanionService::FALLBACK
    end
  end
end
