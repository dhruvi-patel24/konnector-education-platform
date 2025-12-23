class SchoolAdmin::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_school_admin!

  def index
    @courses = policy_scope(Course)
  end

  def new
    @course = current_user.school.courses.new
    authorize @course
  end

  def create
    @course = current_user.school.courses.new(course_params)
    authorize @course

    if @course.save
      redirect_to school_admin_courses_path, notice: "Course created successfully."
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

  def course_params
    params.require(:course).permit(:name, :description)
  end
end
