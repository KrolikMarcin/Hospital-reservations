class PatientsController < ApplicationController
  def index
    @patients = Patient.all
  end

  def new
    @patient = Patient.new
    @patient.build_user
    @patient.user.build_address
  end

  def create
    patient = Patient.new(patient_params)
    patient.user = current_user
    if patient.save
      redirect_to patient_path(patient)
    else
      render :new
    end
  end

  def show
    @patient = Patient.find(params[:id])
  end

  private

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :pesel,
                                    :wants_email, user_attributes:
    [address_attributes: [:street, :house_number, :apartment_number,
                          :city, :postal_code]])
  end
end
