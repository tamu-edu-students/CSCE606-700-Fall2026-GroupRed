class ApplicationController < ActionController::Base
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
      Message.joins(:match)
        .where(seen: false)
        .where.not(sender_id: profile.id)
        .where("matches.profile_1_id = :profile_id OR matches.profile_2_id = :profile_id",
               profile_id: profile.id)
        .count
    else
      0
    end
  end

  def user_not_authorized
    redirect_to not_authorized_path
  end
end
