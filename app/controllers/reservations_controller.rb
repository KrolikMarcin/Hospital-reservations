class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :patient_only, only: [:new, :create, :choice_doctor,
   :choice_doctor_save, :edit, :destroy]
  def index
    @reservations = current_user.reservations.order(date_time: :desc)
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @reservation = Reservation.new
    @specializations = User.specializations
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.users << current_user
    if @reservation.save
      redirect_to reservation_doctor_choice_path(@reservation)
    else
      @specializations = User.specializations
      render :new
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
    @specializations = User.specializations
  end

  def update
    @reservation = Reservation.find(params[:id])
    if @reservation.update(reservation_params)
      redirect_to reservation_path(@reservation)
    else
      render :edit
    end
  end

  def destroy
    reservation = Reservation.find(params[:id])
    reservation.destroy
    redirect_to reservations_path
  end

  def doctor_choice
    @reservation = Reservation.find(params[:reservation_id])
    @doctors = User.free_employees(
      @reservation.doctor_specialization, @reservation.date_time
    ).collect { |doctor| [doctor.full_name, doctor.id] }
  end

  def doctor_choice_save
    reservation = Reservation.find(params[:reservation_id])
    reservation.remove_doctor_if_exists
    doctor = User.find(reservation_params[:user_ids])
    reservation.users << doctor
    redirect_to reservations_path
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :doctor_specialization, :symptoms, :date_time, :user_ids, :diagnosis
    )
  end
end
