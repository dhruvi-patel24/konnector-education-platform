class SchoolAdmin::BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_school_admin!

  def index
    @batches = policy_scope(Batch)
  end

  def new
    @batch = Batch.new
    authorize @batch
  end

  def create
    @batch = Batch.new(batch_params)
    authorize @batch

    if @batch.save
      redirect_to school_admin_batches_path, notice: "Batch created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def ensure_school_admin!
    unless current_user.school_admin?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def batch_params
    params.require(:batch).permit(:name, :course_id, :start_date, :end_date)
  end
end
