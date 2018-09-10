class PrescriptionsController < ApplicationController
  before_action :patient_only
  def index
    @prescriptions = Prescription.where(user: current_user)
  end
end