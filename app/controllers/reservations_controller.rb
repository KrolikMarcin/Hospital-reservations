class ReservationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @reservations = Reservation.all
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @reservation = Reservation.new
    @specializations = Employee.pluck(:specialization).uniq
  end

  def create
    reservation = Reservation.new(reservation_params)
    reservation.user = current_user
    if Employee.employees_without_appointments(
      reservation.doctor_specialization, reservation.date_time
    ).empty?
      @bad_choice = 'There are no vacancies at the given time! Change date!'
      @reservation = Reservation.new
      @specializations = Employee.pluck(:specialization).uniq
      render :new
    else
      reservation.save
      appointment = Appointment.new
      appointment.date_time = reservation.date_time
      appointment.reservation = reservation
      appointment.save
      redirect_to patient_reservation_appointment_doctor_choice_path(
        current_user.patient, reservation, appointment
      )
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :doctor_specialization, :symptoms, :date_time
    )
  end
end
