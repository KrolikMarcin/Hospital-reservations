class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, keys: [patient_attributes: [
        :first_name, :last_name, :wants_email, :pesel, address_attributes: [
          :street, :house_number, :apartment_number, :city, :postal_code
        ]]]
    )
  end
end
