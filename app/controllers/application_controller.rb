class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:school_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:school_id])
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_schools_path
    elsif resource.school_admin?
      root_path
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  def after_update_path_for(resource)
    root_path
  end
end
