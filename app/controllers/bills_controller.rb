class BillsController < ApplicationController
  def index
    @bills = if current_user.admin
               Bill.all.order(payment_date: :desc)
             elsif !current_user.employee
               Bill.where(user: current_user).order(payment_date: :desc)
             end
  end

  def new
    @bill = Bill.new
    3.times do
      @bill.bill_items.build
    end
  end

  def create
    bill = Bill.new(bill_params)
    appointment = Appointment.find(params[:appointment_id])
    bill.appointment = appointment
    bill.user = appointment.reservation.users.where(employee: false)
    bill.payment_date = bill.check_date
    bill.amount = bill.bill_items.sum(&:price)
    if bill.save
      redirect_to appointment_path(appointment)
    else
      @bill = Bill.new
      3.times do
        @bill.bill_items.build
      end
      render :new
    end
  end

  def not_paid
    @bills = Bill.where(paid: false)
  end

  private

  def bill_params
    params.require(:bill).permit(:paid,
                                 bill_items_attributes: [:description, :price])
  end
end
