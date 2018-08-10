class BillsController < ApplicationController
  def index
    pry binding
    patient = Appointment.find(params[:appointment_id]).reservation.user
    @bills = patient.reservations.collect do |r|
      r.appointment.bill.amount
    end
  end

  def new
    @bill = Bill.new
  end

  def create
    bill = Bill.new(bill_params)
    appointment = Appointment.find(params[:appointment_id])
    bill.appointment = appointment
    bill.amount = bill.bill_items.sum('price')
    if bill.save
      redirect_to appointment_bills_path
    else
      @bill = Bill.new
      render :new
    end
  end

  private

  def bill_params
    params.require(:bill).permit(:amount, bill_items_attributes: [:description, :price])
  end
end
