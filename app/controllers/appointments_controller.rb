class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  def index
    if params[:patient_id]
      reservation_ids = Patient.find(params[:patient_id])
                               .user.reservations.pluck(:id)
      @appointments = Appointment.where(reservation_id: reservation_ids)
    else
      @appointments = Appointment.all
    end
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  def change_status
    appointment = Appointment.find(params[:appointment_id])
    appointment.status = true
    appointment.save
    redirect_to new_appointment_bill_path(appointment)
  end

  private

  def appointment_params
    params.require(:appointment).permit(:employee_ids)
  end
end
