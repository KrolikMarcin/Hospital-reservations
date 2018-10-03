class Admin::ReservationsController < ApplicationController
  before_action :admin_only
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
end
