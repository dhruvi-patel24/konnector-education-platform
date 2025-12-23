class CoursePolicy < ApplicationPolicy
  def index?
    user.admin? || user.school_admin?
  end

  def show?
    user.admin? || user.school_id == record.school_id
  end

  def create?
    user.school_admin? && user.school_id == record.school_id
  end

  def update?
    user.school_admin? && user.school_id == record.school_id
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(school_id: user.school_id)
      end
    end
  end
end
