class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  def index
    @appointments = Appointment.all
  end

  def new
    @appointment = Appointment.new
    @reservations = Reservation.where(date_time: Time.now.all_day).pluck(:date_time, :id)
    3.times do
      @appointment.prescriptions.build
    end
  end

  def create
    appointment = Appointment.new(appointment_params)
    reservation = Reservation.find(appointment_params[:reservation_id])
    appointment.reservation = reservation
    if appointment.save
      redirect_to new_appointment_bill_path(appointment)
    else
      @appointment = Appointment.new
      @reservations = Reservation.where(date_time: Time.now.all_day)
                                 .pluck(:date_time, :id)
      3.times do
        @appointment.prescriptions.build
      end
      render :new
    end
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  private

  def appointment_params
    params.require(:appointment)
          .permit(:reservation_id, :diagnosis, prescriptions_attributes:
      [:medicine, :recommendations])
  end
end
