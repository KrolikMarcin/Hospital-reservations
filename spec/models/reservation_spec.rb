require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context 'remove_doctor_if_exists' do
    before do
      @reservation = create(:reservation_with_patient)
    end
    it 'without existing doctor' do
      @reservation.remove_doctor_if_exists
      expect(@reservation.users).to eq([@reservation.patient])
    end
    it 'with existing doctor' do
      doctor = create(:user_doctor)
      @reservation.users << doctor
      @reservation.remove_doctor_if_exists
      expect(@reservation.users).to eq([@reservation.patient])
    end
  end

  context 'assign_patient_to_prescriptions' do
    before do
      @reservation = create(:reservation_with_patient)
    end

    it 'with one prescription' do
      @prescription = build(:prescription)
      @reservation.prescriptions << @prescription
      @reservation.assign_patient_to_prescriptions
      expect(@prescription.user).to eq(@reservation.patient)
    end

    it 'without prescriptions' do
      @reservation.assign_patient_to_prescriptions
      expect(@reservation.prescriptions).to eq([])
    end
  end

  context 'check_status' do
    it 'status false' do
      reservation = build(:reservation)
      expect(reservation.check_status).to eq('X')
    end

    it 'status true' do
      reservation = build(:reservation, status: true)
      expect(reservation.check_status).to eq('V')
    end
  end

  context 'date_formated' do
    it 'format date' do
      reservation = build(:reservation, date_time:
                          Time.new(2000, 10, 10, 18, 30, 0, 0))
      expect(reservation.date_formated).to eq('Tue, 10-10-2000 18:30')
    end
  end
end
