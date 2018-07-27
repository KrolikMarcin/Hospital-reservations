class AppointmentsController < ApplicationController

  def index
    @appointments = Appointment.all
  end
  def show

  end
  def new 
    @appointment = Appointment.new
    @reservations = Reservation.pluck(:preferred_hour, :id)
    @staff = Staff.pluck(:first_name, :id)
    @appointment_staff = [:nurse_with_doctor, :doctor]
    
  end

  def create 
    @appointment = Appointment.new(appointment_params)
    reservation =  Reservation.find(appointment_params[:reservation_id])
    @appointment.reservation = reservation
    @appointment.appointment_staff = appointment_params[:appointment_staff]
   
    

    
    if @appointment.save
      redirect_to appointment_new_staff_choices_path(@appointment)
    else
      @reservations = Reservation.pluck(:preferred_hour, :id)
      @appointment_staff = [:nurse_with_doctor, :doctor]
      render :new
    end
  end

  def new_staff_choices
    
    @appointment = Appointment.find(params[:appointment_id])
    doctor_specialization = @appointment.reservation.doctor_specialization
   
    @doctors = Staff.where(specialization: doctor_specialization).pluck(:first_name, :specialization, :id)
    @nurses = Staff.where(specialization: :nurse).pluck(:first_name, :specialization, :id)
  
  end

  def create_staff_choices
    @appointment = Appointment.find(appointment_params[:appointment_id])
    doctor = Staff.find(appointment_params[:staff_ids])
    @appointment << doctor
    # if @appointment.appointment_staff == :nurse_with_doctor
    #   @appointment << nurse
    if @appointment.save
      redirect_to appointments
    else
      render :new_staff_choices
    end
  end
  private

    def appointment_params
      params.require(:appointment).permit(
        :appointment_date, :appointment_hour, :appointment_staff, :reservation_id, :staff_ids, :appointment_id
      )
    end
end