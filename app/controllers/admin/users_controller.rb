module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def suspend
      authorize :admin, :show?
      person = User.find_by(id: params[:id])
      return redirect_to(admin_path, alert: "That account isn't available.") unless person

      person.update!(suspended_at: Time.current)
      redirect_to admin_path, notice: "#{person.display_name} is suspended."
    end

    def pardon
      authorize :admin, :show?
      person = User.find_by(id: params[:id])
      return redirect_to(admin_path, alert: "That account isn't available.") unless person

      person.update!(suspended_at: nil)
      redirect_to admin_path, notice: "#{person.display_name} is pardoned."
    end
  end
end
