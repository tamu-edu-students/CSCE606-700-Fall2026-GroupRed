class MessagePolicy < ApplicationPolicy
  # two poeple in match can open
  # if blocked close
  def show?
    profile = user&.profile
    return false unless profile && record.includes?(profile)

    other_user = record.other_profile(profile).user

    return false if other_user.suspended?

    !user.blocked_with?(other_user)
  end

  def create?
    show?
  end
end
