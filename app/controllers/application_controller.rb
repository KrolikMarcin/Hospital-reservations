class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:
      [:role, :first_name, :last_name, :pesel, :want_email, address_attributes:
      [:street, :house_number, :apartment_number, :city, :postal_code]])
  end

  def after_sign_in_path_for(resource)
    if resource.class == User && !resource.userable && resource.role
      new_employee_path
    elsif resource.class == User && !resource.userable && !resource.role
      new_patient_path
    else stored_location_for(resource) || root_path
    end
  end
end
