class CompanionMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    profile = Profile.joins(:user)
                     .merge(User.not_blocked_with(current_user))
                     .where.not(user: current_user)
                     .find_by(id: params[:profile_id])
    return redirect_to swipes_path, alert: "That profile isn't available." unless profile

    companion = current_user.companion || current_user.create_companion!
    message = companion.companion_messages.new(profile: profile, role: "user", body: params[:body].to_s.strip)

    unless message.valid?
      return redirect_to swipes_path, alert: message.errors.full_messages.to_sentence
    end

    if CompanionService.reply(companion, profile, message.body)
      redirect_to swipes_path
    else
      redirect_to swipes_path, alert: CompanionService::FALLBACK
    end
  end
end
