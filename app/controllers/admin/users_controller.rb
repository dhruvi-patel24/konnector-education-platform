class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  ALLOWED_ROLES = %w[admin school_admin student].freeze

  def index
    @role = params[:role] || "school_admin"
    @users = User.where(role: @role)

    respond_to do |format|
      format.html
    end
  end

  def new
    @user = User.new(role: params[:role] || "student")
  end

  def create
    @user = User.new(user_params)
    @user.role = safe_role

    if @user.save
      redirect_to admin_users_path(role: @user.role), notice: "#{ @user.role.titleize } was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path(role: @user.role), notice: "#{ @user.role.titleize } was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    role = @user.role
    @user.destroy
    redirect_to admin_users_path(role: role), notice: "#{ role.titleize } was successfully deleted."
  end

  private

  def ensure_admin!
    unless current_user.admin?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :school_id)
  end

  def safe_role
    role = params[:role] || params.dig(:user, :role)
    ALLOWED_ROLES.include?(role) ? role : "student"
  end
end
