class AppointmentsController < ApplicationController
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

  def doctor_choice
    @appointment = Appointment.find(params[:appointment_id])
    reservation = @appointment.reservation
    @doctors = Employee.employees_without_appointments(
      reservation.doctor_specialization, reservation.date_time
    )
    @doctors = Employee.sort_by_appointments(@doctors, reservation.date_time)
                       .collect(&:full_name)
  end

  def doctor_choice_save
    appointment = Appointment.find(params[:appointment_id])
    doctor = Employee.find(appointment_params[:employee_ids])
    appointment.employees << doctor
    redirect_to patient_reservations_path(current_user)
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
