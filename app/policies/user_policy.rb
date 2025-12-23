class UserPolicy < ApplicationPolicy
  def create?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.school_admin?
        scope.where(school_id: user.school_id)
      else
        scope.where(id: user.id)
      end
    end
  end
end
