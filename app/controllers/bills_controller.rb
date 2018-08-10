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
  end

  def create
    bill = Bill.new(bill_params)
    appointment = Appointment.find(params[:appointment_id])
    bill.appointment = appointment
    pry binding
    bill.amount = bill.bill_items.sum(&:price)
    if bill.save
      redirect_to patient_bills_path(appointment.reservation.user.patient)
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
