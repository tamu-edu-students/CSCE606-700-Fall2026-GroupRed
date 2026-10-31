class CompanionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_companion

  def show
    @greeting = CompanionService.greet(@companion)
  end

  def edit
  end

  def update
    if @companion.update(companion_params)
      redirect_to companion_path, notice: "#{@companion.name} is all set."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_companion
    @companion = current_user.companion || current_user.create_companion!
  end

  def companion_params
    params.expect(companion: [ :name, :personality ])
  end
end
