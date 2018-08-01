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
    @reservation = Reservation.new(reservation_params)
    specialization = reservation_params[:doctor_specialization]
    @reservation.user = current_user
    @reservation.doctor_specialization = specialization

    if @reservation.save
      redirect_to reservation_path(@reservation)
    else
      render :new
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :doctor_specialization, :symptoms, :date_time
    )
  end
end
