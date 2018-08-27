class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  def index
    @appointments = Appointment.all
  end

  def new
    @appointment = Appointment.new
    @reservations = Reservation.where(date_time: Time.now.all_day).pluck(:date_time, :id)
    @appointment.build_bill
    5.times do
      @appointment.bill.bill_items.build
    end
  end

  def create
    appointment = Appointment.new(appointment_params)
    reservation = Reservation.find(appointment_params[:reservation_id])
    appointment.reservation = reservation
    appointment.bill.payment_date = appointment.bill.check_date
    appointment.bill.amount = appointment.bill.bill_items.sum(&:price)
    if appointment.save
      pry binding
      redirect_to appointments_path(appointment)
    else
      @appointment = Appointment.new
      @reservations = Reservation.where(date_time: Time.now.all_day)
                                 .pluck(:date_time, :id)
      @appointment.build_bill
      5.times do
        @appointment.bill.bill_items.build
      end
      render :new
    end
  end

  def show
    @appointment = Appointment.find(params[:format])
  end

  private

  def appointment_params
    params.require(:appointment)
          .permit(:reservation_id, :diagnosis, bill_attributes:
    [:payment_date, :payment_status, bill_items_attributes:
    [:description, :price]])
  end
end
