class PrescriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :patient_only

  def index
    @prescriptions = if params[:format]
                       Reservation.find(params[:format]).prescriptions
                     else
                       Prescription.where(user: current_user)
                     end
  end

  def show
    @prescription = Prescription.find(params[:id])
  end
end
