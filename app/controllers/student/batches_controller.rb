class Student::BatchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @batches = current_user.batches.joins(:enrollments).where(enrollments: { status: :approved })
  end

  def show
    @batch = Batch.find(params[:id])
    authorize @batch, :classmates?
    @classmates = @batch.students.where.not(id: current_user.id)
    @enrollments = @batch.enrollments.where(user_id: @classmates.pluck(:id))
  end
end
