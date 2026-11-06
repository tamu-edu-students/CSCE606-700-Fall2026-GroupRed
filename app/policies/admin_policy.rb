class AdminPolicy < ApplicationPolicy
  def show?
    user&.role == "admin"
  end
end