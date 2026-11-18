class MessageReportsController < ApplicationController
  include MatchConversation

  before_action :authenticate_user!
  before_action :require_profile
  before_action :set_match

  def create
    message = @match.messages.find_by(id: params[:message_id])
    if message.nil? || message.sender_id == @profile.id
      return redirect_to(match_path(@match), alert: "That message can't be reported.")
    end

    reason = "Reported message: \"#{message.body.truncate(400)}\""
    if current_user.reports.exists?(reportable: @other_profile.user, reason: reason)
      return redirect_to(match_path(@match), notice: "You already reported that message.")
    end

    report = current_user.reports.new(reportable: @other_profile.user, reason: reason)
    authorize report
    report.save!

    redirect_to match_path(@match), notice: "Thanks. We'll review that message."
  end
end
