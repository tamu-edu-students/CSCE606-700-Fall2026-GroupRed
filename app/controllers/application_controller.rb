class ApplicationController < ActionController::Base
  UNAUTHORIZED_ALERT = "You are not authorized to perform this action.".freeze

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_unread_message_count, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :date_of_birth ])
  end

  private

  def set_unread_message_count
    profile = current_user.profile
    @unread_message_count = if profile
      visible_match_ids = Match
        .involving(profile)
        .not_blocked_with(profile)
        .not_suspended_with(profile)
        .select(:id)

      Message
        .where(match_id: visible_match_ids)
        .where(seen: false)
        .where.not(sender_id: profile.id)
        .count
    else
      0
    end
  end

  def user_not_authorized
    fallback_location = current_user&.profile ? matches_path : root_path
    redirect_back fallback_location: fallback_location, alert: UNAUTHORIZED_ALERT
  end
end
