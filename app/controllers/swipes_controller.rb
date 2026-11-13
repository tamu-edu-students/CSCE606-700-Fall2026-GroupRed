class SwipesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[index create history undo change_decision]

  def index
    @prospect = find_potential_profiles.order(:id).first
    return unless @prospect

    @companion = current_user.companion || current_user.create_companion!
    @reaction = CompanionService.react(@companion, @prospect)
    @messages = @companion.companion_messages.about(@prospect)
  end

  def create
      prospect = Profile.joins(:user)
                      .merge(User.not_blocked_with(@profile.user))
                      .find_by(id: params[:prospect_id])

    unless prospect
      redirect_to swipes_path, alert: "That profile is unavailable."
      return
    end

    @swipe = Swipe.new(
      swiper_id: @profile.id,
      prospect_id: prospect.id,
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
      redirect_to swipes_path
    else
      redirect_to swipes_path, alert: "Failed to record swipe."
    end
  end

  def history
    @swipes = Swipe.where(swiper_id: @profile.id).order(created_at: :desc)
    # Unsure no blocked users don't show up in history, but this is a good safety check.
    @swipes = @swipes.joins(prospect: :user).merge(User.not_blocked_with(@profile.user))
  end

  def undo
    last_swipe = Swipe.where(swiper_id: @profile.id).order(created_at: :desc).first
    if last_swipe
      last_swipe.destroy
      flash[:notice] = "Last swipe undone."
      if last_swipe.liked
        # If the last swipe was a like, check if there was a match and remove it
        match = Match.find_by(profile_1_id: [ last_swipe.swiper_id, last_swipe.prospect_id ].min, profile_2_id: [ last_swipe.swiper_id, last_swipe.prospect_id ].max)
        match.destroy if match
      end
    else
      flash[:alert] = "No swipes to undo."
    end
    redirect_to swipes_path
  end

  def change_decision
    swipe = Swipe.find_by(id: params[:swipe_id], swiper_id: @profile.id)
    decision = params[:new_decision]

    if swipe && %w[like dislike].include?(decision)
      if swipe.update(liked: decision == "like")
        flash[:notice] = "Swipe decision updated."
        if swipe.liked
          # Check if the prospect has also liked the swiper.
          if Swipe.exists?(swiper_id: swipe.prospect_id, prospect_id: swipe.swiper_id, liked: true)
            # Create a match if both have liked each other.
            profile_ids = [ swipe.swiper_id, swipe.prospect_id ].sort
            Match.find_or_create_by!(profile_1_id: profile_ids[0], profile_2_id: profile_ids[1])
            flash[:notice] = "It's a match!"
          end
        else
          # If the decision was changed to dislike, remove any existing match.
          match = Match.find_by(profile_1_id: [ swipe.swiper_id, swipe.prospect_id ].min, profile_2_id: [ swipe.swiper_id, swipe.prospect_id ].max)
          match.destroy if match
        end
      else
        flash[:alert] = "Failed to update swipe decision."
      end
    elsif swipe
      flash[:alert] = "Invalid swipe decision."
    else
      flash[:alert] = "Swipe not found."
    end
    redirect_to history_index_path
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
                      .merge(User.not_blocked_with(@profile.user))
                      .where(users: { date_of_birth: youngest_date_of_birth..oldest_date_of_birth })
                      .where.not(id: @profile.id)
                      .where.not(
                        id: Swipe.where(swiper_id: @profile.id)
                                  .select(:prospect_id)
                      )
                      .where(users: { suspended_at: nil })

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
