class Admin::BillsController < ApplicationController
  before_action :authenticate_user!
  befor_action :admin_only

  def index
    @bills = if params[:format]
               Bill.send(params[:format].to_sym)
             else
               Bill.all.order(payment_date: :desc)
             end
  end

  def show
    @bill = Bill.find(params[:id])
  end

  def new
    @bill = Bill.new
    3.times do
      @bill.bill_items.build
    end
  end

  def create
    @bill = Bill.new(bill_params)
    reservation = Reservation.find(params[:reservation_id])
    @bill.user = reservation.patient
    @bill.payment_date = @bill.check_paid
    @bill.amount = @bill.bill_items.sum(&:price)
    if @bill.save
      redirect_to reservation_path(reservation)
    else
      render :new
    end
  end

  def pay_bill
    bill = Bill.find(params[:bill_id])
    bill.update(paid: true)
    redirect_to bill_path(bill)
  end

  private

  def bill_params
    params.require(:bill).permit(
      :paid, bill_items_attributes: [:description, :price]
    )
  end
end
