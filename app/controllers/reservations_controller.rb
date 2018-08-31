class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reservations = if !current_user.employee
                      current_user.reservations.order(date_time: :desc)
                    else
                      @reservations = Reservation.all.order(date_time: :desc)
                    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @reservation = Reservation.new
    @specializations = User.where(employee: true).pluck(:specialization).uniq
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.users << current_user
    if @reservation.save
      redirect_to reservation_doctor_choice_path(@reservation)
    else
      @specializations = User.where(employee: true).pluck(:specialization).uniq
      render :new
    end
  end

  def doctor_choice
    @reservation = Reservation.find(params[:reservation_id])
    doctors = User.free_employees(
      @reservation.doctor_specialization, @reservation.date_time
    )
    @doctors = User.sort_by_appointments(doctors, @reservation.date_time)
                   .collect { |doctor| [doctor.full_name, doctor.id] }
  end

  def doctor_choice_save
    reservation = Reservation.find(params[:reservation_id])
    doctor = User.find(reservation_params[:user_ids])
    reservation.users << doctor
    redirect_to reservations_path
  end

  def change_status
    @reservation = Reservation.find(params[:reservation_id])
    3.times do
      @reservation.prescriptions.build
    end
  end

  def change_status_save
    @reservation = Reservation.find(params[:reservation_id])
    @reservation.status = true
    @reservation.update(reservation_params)
    @reservation.assign_patient_to_prescriptions
    if @reservation.save
      redirect_to new_reservation_bill_path(@reservation)
    else
      render :change_status
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :doctor_specialization, :symptoms, :date_time, :user_ids, :diagnosis,
      prescriptions_attributes: [:medicine, :recommendations]
    )
  end
end
