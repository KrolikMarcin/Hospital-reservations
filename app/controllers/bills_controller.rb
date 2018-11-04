class BillsController < ApplicationController
  before_action :authenticate_user!
  before_action :patient_only, only: [:index, :pay_bill]
  before_action :admin_and_patient, only: :show

  def index
    @bills = Bill.where(user: current_user).order(payment_date: :desc).page(params[:page])
  end

  def show
    @bill = Bill.find(params[:id])
  end

  def pay_bill
    # will be implement possibility to pay by bank transfer
    @bill = Bill.find(params[:bill_id])
    @bill.update(paid: true, payment_date: Time.now)
    redirect_to bill_path(@bill)
  end
end
