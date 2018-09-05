class Admin::ReservationsController < ApplicationController
  before_action :admin_only, only: [:index, :change_status, :change_status_save]
  before_action :authenticate_user!
  def index
    @reservations = if params[:format]
                      Reservation.send(params[:format].to_sym)
                    else
                      Reservation.all.order(date_time: :desc)
                    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def change_status
    @reservation = Reservation.find(params[:reservation_id])
    3.times do
      @reservation.prescriptions.build
    end
  end

  def change_status_save
    @reservation = Reservation.find(params[:reservation_id])
    @reservation.update(prescriptions_params[:prescriptions_attributes])
    @reservation.status = true
    @reservation.assign_patient_to_prescriptions
    if @reservation.save
      redirect_to new_reservation_bill_path(@reservation)
    else
      render :change_status
    end
  end

  def destroy
    reservation = Reservation.find(params[:id])
    reservation.destroy
    redirect_to reservations_path
  end

  private

  def prescriptions_params
    require(:reservation).permit(prescriptions_attributes: [:medicine, :recommendations])
  end

end
