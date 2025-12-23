class EnrollmentPolicy < ApplicationPolicy
  def index?
    user.admin? || user.school_admin? || user.student?
  end

  def create?
    user.student? || (user.school_admin? && user.school_id == record.batch.course.school_id)
  end

  def update?
    user.school_admin? && user.school_id == record.batch.course.school_id
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.school_admin?
        scope.joins(batch: :course).where(courses: { school_id: user.school_id })
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
