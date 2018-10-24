class Admin::ReservationsController < ApplicationController
  before_action :admin_only
  before_action :authenticate_user!
  def index
    if params[:date]
      @doctors = User.doctors_with_reservations_in_chosen_day(params[:date].to_date)
      render :index_with_chosen_date
    else
      @reservations = Reservation.all
      render :month_calendar
    end
  end
end
