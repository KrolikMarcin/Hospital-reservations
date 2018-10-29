class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:
      [:first_name, :last_name, :pesel, :want_email, :specialization, :roles])
  end

  def admin_only
    redirect_back(fallback_location: root_path, alert: 'Access denied.') unless
      current_user.admin?
  end

  def patient_only
    redirect_back(fallback_location: root_path, alert: 'Access denied.') unless
      current_user.patient?
  end

  def doctor_only
    redirect_back(fallback_location: root_path, alert: 'Access denied.') unless
    current_user.doctor?
  end

  def admin_and_patient
    redirect_back(fallback_location: root_path, alert: 'Access denied.') unless
    current_user.admin? || current_user.patient?
  end
end
