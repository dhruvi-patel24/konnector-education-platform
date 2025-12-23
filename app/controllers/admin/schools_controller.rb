class Admin::SchoolsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_school, only: [ :edit, :update, :show, :destroy ]
  def index
    @schools = policy_scope(School)
  end

  def new
    @school = School.new
    authorize @school
  end

  def create
    @school = School.new(school_params)
    authorize @school
    if @school.save
      redirect_to admin_schools_path, notice: "School was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    authorize @school
  end

  def edit
    authorize @school
  end

  def update
    authorize @school
    if @school.update(school_params)
      redirect_to admin_schools_path, notice: "School was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @school.destroy
    redirect_to admin_schools_path, notice: "School deleted successfully."
  end

  private

  def school_params
    params.require(:school).permit(:name, :address)
  end

  def set_school
    @school = School.find params[:id]
  end
end
