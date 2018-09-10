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
