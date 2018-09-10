class BillsController < ApplicationController
  before_action :patient_only

  def index
    @bills = Bill.where(user: current_user).order(payment_date: :desc)
  end

  def show
    @bill = Bill.find(params[:id])
  end

  def pay_bill
    bill = Bill.find(params[:bill_id])
    bill.update(paid: true)
    redirect_to bill_path(bill)
  end
end
