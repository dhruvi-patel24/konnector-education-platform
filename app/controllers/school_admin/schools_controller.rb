class SchoolAdmin::SchoolsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_school
  before_action :ensure_school_admin!

  def edit
    authorize @school
  end

  def update
    authorize @school
    if @school.update(school_params)
      redirect_to edit_school_admin_school_path(@school), notice: "School updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_school
    @school = current_user.school
  end

  def ensure_school_admin!
    unless current_user.school_admin?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def school_params
    params.require(:school).permit(:name, :address)
  end
end
