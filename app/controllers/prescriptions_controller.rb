class PrescriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :patient_only

  def index
    @prescriptions = Prescription.where(user: current_user)
  end

  def show
    @prescription = Prescription.find(params[:id])
  end
end
