class BillsController < ApplicationController
  before_action :patient_only
  def index
    @bills = Bill.where(user: current_user).order(payment_date: :desc)
  end

  def show
    @bill = Bill.find(params[:id])
  end
end
