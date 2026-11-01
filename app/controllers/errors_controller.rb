class ErrorsController < ApplicationController
  skip_before_action :configure_permitted_parameters

  def forbidden
    render file: Rails.public_path.join("403.html"), status: :forbidden, layout: false
  end
end
