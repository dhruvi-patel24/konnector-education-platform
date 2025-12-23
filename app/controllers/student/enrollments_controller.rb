class Student::EnrollmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @enrollments = current_user.enrollments
    @available_batches = Batch.joins(:course).where(courses: { school_id: current_user.school_id })
                              .where.not(id: current_user.batch_ids)
  end

  def create
    @enrollment = current_user.enrollments.build(enrollment_params)
    @enrollment.status = :pending
    authorize @enrollment
    
    if @enrollment.save
      redirect_to student_enrollments_path, notice: 'Enrollment request sent successfully.'
    else
      redirect_to student_enrollments_path, alert: @enrollment.errors.full_messages.to_sentence
    end
  end

  private

  def enrollment_params
    params.require(:enrollment).permit(:batch_id)
  end
end
