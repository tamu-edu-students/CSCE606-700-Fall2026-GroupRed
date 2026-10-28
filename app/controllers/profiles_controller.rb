class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[ show edit update ]
  before_action :redirect_if_profile_exists, only: %i[ new create ]

  def show
  end

  def new
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.build_profile(profile_params)

    if @profile.save
      redirect_to profile_path, notice: "Profile created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  # /profile always means the signed-in user's own profile.
  def set_profile
    @profile = current_user.profile
    redirect_to new_profile_path unless @profile
  end

  # build_profile would replace an existing profile, so send the user to edit instead.
  def redirect_if_profile_exists
    redirect_to edit_profile_path if current_user.profile
  end

  def profile_params
    params.expect(profile: [ :display_name, :bio, :gender, :interested_in, :age_min, :age_max ])
  end
end
