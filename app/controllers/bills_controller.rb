class BillsController < ApplicationController
  befor_action :admin_only, only: [:new, :create, :not_paid]

  def index
    @bills = if current_user.admin
               Bill.all.order(payment_date: :desc)
             elsif current_user.admin && params[:format]
               Bill.not_paid.order(:payment_date)
             else
               Bill.where(user: current_user).order(payment_date: :desc)
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
