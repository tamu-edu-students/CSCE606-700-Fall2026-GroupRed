class CompanionMessageReportsController < ApplicationController
  before_action :authenticate_user!

  def create
    message = current_user.companion&.companion_messages&.find_by(id: params[:companion_message_id], role: "companion")
    return redirect_to(swipes_path, alert: "That reply isn't available.") unless message

    if current_user.reports.exists?(reportable: message)
      return redirect_to swipes_path, notice: "You already reported that reply."
    end

    report = current_user.reports.new(reportable: message, reason: "Flagged companion reply: \"#{message.body.truncate(400)}\"")
    authorize report
    report.save!

    redirect_to swipes_path, notice: "Thanks. We'll review that reply."
  end
end
