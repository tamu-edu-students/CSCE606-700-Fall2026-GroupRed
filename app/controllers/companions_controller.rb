class CompanionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @companion = current_user.companion || current_user.create_companion!
    @greeting = CompanionService.greet(@companion)
  end
end
