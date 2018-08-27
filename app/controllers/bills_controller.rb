class BillsController < ApplicationController
  def index
    reservations_ids = Patient.find(params[:patient_id])
                              .user.reservations.pluck(:id)
    appointments_ids = Appointment.where(reservation_id: reservations_ids)
                                  .pluck(:id)
    @bills = Bill.where(appointment_id: appointments_ids)
  end

  def not_paid
    @bills = Bill.where(payment_status: false)
  end
end
