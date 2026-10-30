class SwipesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[index create]

  def index
    @prospect = find_potential_profiles.order(:id).first
  end

  def create
    @swipe = Swipe.new(
      swiper_id: @profile.id,
      prospect_id: params[:prospect_id],
      liked: params[:action_type] == "like"
    )

    if @swipe.save
      flash[:notice] = "Swipe recorded successfully."
      if @swipe.liked
        # Check if the prospect has also liked the swiper.
        if Swipe.exists?(swiper_id: @swipe.prospect_id, prospect_id: @swipe.swiper_id, liked: true)
          # Create a match if both have liked each other.
          profile_ids = [ @swipe.swiper_id, @swipe.prospect_id ].sort
          Match.find_or_create_by!(profile_1_id: profile_ids[0], profile_2_id: profile_ids[1])
          flash[:notice] = "It's a match!"
        end
      end
    else
      redirect_to swipes_path, alert: "Failed to record swipe."
    end
  end

  private

  def set_profile
    @profile = current_user.profile
    redirect_to new_profile_path unless @profile
  end

  def find_potential_profiles
    return Profile.none unless @profile.age_min && @profile.age_max

    today = Date.current
    youngest_date_of_birth = today - (@profile.age_max + 1).years + 1.day
    oldest_date_of_birth = today - @profile.age_min.years

    prospects = Profile.joins(:user)
                      .where(users: { date_of_birth: youngest_date_of_birth..oldest_date_of_birth })
                      .where.not(id: @profile.id)
                      .where.not(
                        id: Swipe.where(swiper_id: @profile.id)
                                  .select(:prospect_id)
                      )

    # The prospect must match the current profile's gender preference.
    case @profile.interested_in
    when "Men"
      prospects = prospects.where(gender: "Man")
    when "Women"
      prospects = prospects.where(gender: "Woman")
    when "Everyone"
      # No gender restriction.
    else
      return Profile.none
    end

    # The prospect must also accept the current profile's age.
    prospects = prospects.where(
      "age_min <= ? AND age_max >= ?",
      @profile.age,
      @profile.age
    )

    # The prospect must also be interested in the current profile's gender.
    case @profile.gender
    when "Man"
      prospects = prospects.where(interested_in: %w[Men Everyone])
    when "Woman"
      prospects = prospects.where(interested_in: %w[Women Everyone])
    when "Non-binary"
      prospects = prospects.where(interested_in: "Everyone")
    else
      return Profile.none
    end

    prospects
  end
end
