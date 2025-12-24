class SchoolAdmin::EnrollmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_school_admin!

  def index
    @enrollments = policy_scope(Enrollment)
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    batch = Batch.find(params[:enrollment][:batch_id])
    if batch.course.school == current_user.school
       @enrollment.status = :approved # Auto-approve if created by school admin
       if @enrollment.save
         redirect_to school_admin_enrollments_path, notice: "Enrollment created successfully."
       else
         @enrollments = policy_scope(Enrollment)
         render :index, status: :unprocessable_entity
       end
    else
      @enrollments = policy_scope(Enrollment)
      flash.now[:alert] = "You are not authorized to enroll students in this batch."
      render :index, status: :unprocessable_entity
    end
  end

  def update
    @enrollment = Enrollment.find(params[:id])
    authorize @enrollment

    if @enrollment.update(enrollment_params)
      redirect_to school_admin_enrollments_path, notice: "Enrollment updated successfully."
    else
      @enrollments = policy_scope(Enrollment)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def ensure_school_admin!
    unless current_user.school_admin?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def enrollment_params
    params.require(:enrollment).permit(:user_id, :batch_id, :status)
  end
end
