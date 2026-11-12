class MessagePolicy < ApplicationPolicy
  # two poeple in match can open
  # if blocked close
  def show?
    profile = user&.profile
    return false unless profile && record.includes?(profile)

    !user.blocked_with?(record.other_profile(profile).user)
  end

  def create?
    show?
  end
end
