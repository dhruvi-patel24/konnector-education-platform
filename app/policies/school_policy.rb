class SchoolPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || user.school_id == record.id
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || (user.school_admin? && user.school_id == record.id)
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.school_id)
      end
    end
  end
end
