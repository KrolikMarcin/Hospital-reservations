class BillsController < ApplicationController
  def index
    reservations_ids = Patient.find(params[:patient_id])
                              .user.reservations.pluck(:id)
    appointments_ids = Appointment.where(reservation_id: reservations_ids)
                                  .pluck(:id)
    @bills = Bill.where(appointment_id: appointments_ids)
  end

  def new
    @bill = Bill.new
    4.times do
      @bill.bill_items.build
    end
  end

  def create
    pry binding
    bill = Bill.new(bill_params)
    appointment = Appointment.find(params[:appointment_id])
    bill.appointment = appointment
    bill.payment_date = bill.check_date
    bill.amount = bill.bill_items.sum(&:price)
    if bill.save
      redirect_to appointment_path(appointment)
    else
      @bill = Bill.new
      4.times do
        @bill.bill_items.build
      end
      render :new
    end
  end

  def not_paid
    @bills = Bill.where(payment_status: false)
  end

  private

  def bill_params
    params.require(:bill).permit(:paid,
                                 bill_items_attributes: [:description, :price])
  end
end
