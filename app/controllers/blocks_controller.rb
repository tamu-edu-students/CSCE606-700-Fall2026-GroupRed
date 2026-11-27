class BlocksController < ApplicationController
  before_action :authenticate_user!

  def index
    @blocked_users = current_user.blocked_users.includes(:profile).order("blocks.created_at DESC")
  end

  # Confirmation page, so the warning shows even without JavaScript (ADR 0002).
  def new
    @person = User.includes(:profile).find_by(id: params[:person_id])
    return redirect_to profile_path if @person == current_user

    # Same message as the profile page for missing and blocked people.
    if @person&.profile.nil? || current_user.blocked_with?(@person)
      redirect_to root_path, alert: PeopleController::NOT_AVAILABLE
    end
  end

  def create
    person = User.find_by(id: params[:person_id])
    return redirect_to root_path, alert: PeopleController::NOT_AVAILABLE unless person

    block = current_user.blocks.find_or_initialize_by(blocked: person)

    if block.persisted? || block.save
      redirect_to blocks_path, notice: "You blocked #{person.display_name}. They can no longer see or contact you."
    else
      redirect_to root_path, alert: block.errors.full_messages.to_sentence
    end
  end

  def destroy
    block = current_user.blocks.includes(blocked: :profile).find_by(blocked_id: params[:person_id])
    return redirect_to blocks_path, alert: "That person isn't blocked." unless block

    block.destroy
    redirect_to blocks_path, notice: "#{block.blocked.display_name} is unblocked."
  end
end
