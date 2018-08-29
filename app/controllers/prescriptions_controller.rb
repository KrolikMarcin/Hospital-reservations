class PrescriptionsController < ApplicationController
  def index
    @prescriptions = Prescription.where(user: current_user)
  end
end