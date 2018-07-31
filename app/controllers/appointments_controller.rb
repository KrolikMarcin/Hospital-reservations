class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.all
  end

  def show
  end

  def new
    @appointment = Appointment.new
    @reservations = Reservation.pluck(:date_time, :id)
  end

  def create
    @appointment = Appointment.new(appointment_params)
    pry binding
    reservation = Reservation.find(appointment_params[:reservation_id])
    @appointment.reservation = reservation
    @appointment.nurse_help = appointment_params[:nurse_help]
    if @appointment.save
      redirect_to appointment_new_employees_choices_path(@appointment)
    else
      @reservations = Reservation.pluck(:date_time, :id)
      render :new
    end
  end

  def new_employees_choices
    @appointment = Appointment.find(params[:appointment_id])
    doctor_specialization = @appointment.reservation.doctor_specialization
    @doctors = employees_without_appointments(
      doctor_specialization, @appointment.date_time
    ).pluck(:first_name, :id)
  end

  def create_employees_choices
    @appointment = Appointment.find(params[:appointment_id])
    pry binding
    doctor = Employee.find(appointment_params[:employee_ids])
    @appointment.employees << doctor
    if @appointment.save
      redirect_to appointments_path
    else
      render :new_employees_choices
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(
      :nurse_help, :reservation_id, :employee_ids, :appointment_id, :date_time
    )
  end

  def employees_without_appointments(specialization, date_time)
    Employee.where(specialization: specialization).joins(:appointments).where.not(
      appointments: { date_time: date_time }
    )
  end

  # def sort_by_appointments(employees)
  #   employees.sort_by do |employee|
  #     employee.appointments.where(appointment_date:
  #       @appointment.appointment_date).count
  #   end
  # end
end
