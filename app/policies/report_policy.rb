class ReportPolicy < ApplicationPolicy
  # Any signed-in user can report someone else
  def create?
    user.present? && record.reporter == user && record.reportable != user
  end

  # Admins see every report (used by #11); everyone else sees their own
  class Scope < ApplicationPolicy::Scope
    def resolve
      user&.admin? ? scope.all : scope.where(reporter: user)
    end
  end
end
