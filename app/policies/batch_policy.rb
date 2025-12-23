class BatchPolicy < ApplicationPolicy
  def index?
    user.admin? || user.school_admin? || user.student?
  end

  def show?
    user.admin? || (record.course && user.school_id == record.course.school_id)
  end

  def new?
    user.school_admin?
  end

  def create?
    user.school_admin? && (record.course.nil? || user.school_id == record.course.school_id)
  end

  def update?
    user.school_admin? && (record.course.nil? || user.school_id == record.course.school_id)
  end

  def classmates?
    user.student? && user.batches.include?(record)
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.school_admin?
        scope.joins(:course).where(courses: { school_id: user.school_id })
      else
        # Students can see batches they are enrolled in
        scope.joins(:enrollments).where(enrollments: { user_id: user.id, status: :approved })
      end
    end
  end
end
