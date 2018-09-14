class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:
      [:employee, :first_name, :last_name, :pesel, :want_email, :specialization])
  end

  def admin_only
    redirect_back(fallback_location: root_path, alert: 'Access denied.') unless
      current_user.admin?
  end

  def patient_only
    redirect_back(fallback_location: root_path, alert: 'Access denied.') if
      current_user.employee? || current_user.admin?
  end

  def employee_only
    redirect_back(fallback_location: root_path, alert: 'Access denied.') if
    !current_user.employee? || current_user.admin?
  end
end
