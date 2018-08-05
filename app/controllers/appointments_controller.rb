class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.all
  end

  def show
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
    redirect_to patient_reservations_path
  end

  private

  def appointment_params
    params.require(:appointment).permit(:employee_ids)
  end
end
