require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context '#remove_doctor_if_exists' do
    before do
      @doctor = create(:user_doctor)
      @reservation = create(:reservation_with_patient,
                            doctor_specialization: @doctor.specialization)
    end
    it 'returns reservation without doctor if doctor not assigns to reservation' do
      @reservation.remove_doctor_if_exists
      expect(@reservation.users).to eq([@reservation.patient])
    end
    it 'returns reservation with removed doctors if doctor is assigns to reservation' do
      @reservation.users << @doctor
      @reservation.remove_doctor_if_exists
      expect(@reservation.users).to eq([@reservation.patient])
    end
  end

  context '#assign_patient_to_prescriptions' do
    before do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      @reservation = create(:reservation_with_patient_and_doctor)
    end

    it 'returns prescriptions with assigns patient' do
      @prescription = build(:prescription)
      @reservation.prescriptions << @prescription
      @reservation.assign_patient_to_prescriptions
      expect(@prescription.user).to eq(@reservation.patient)
    end
  end

  context '#check_status' do
    it 'returns X if the appointment not been yet' do
      reservation = build(:reservation)
      expect(reservation.check_status).to eq('X')
    end

    it 'returns V if the reservation was been' do
      reservation = build(:reservation, status: true)
      expect(reservation.check_status).to eq('V')
    end
  end

  context '#date_formated' do
    it 'returns formatted date' do
      reservation = build(:reservation, date_time:
                          Time.new(2000, 10, 10, 18, 30, 0, 0))
      expect(reservation.date_formated).to eq('Tue, 10-10-2000 18:30')
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:doctor_specialization) }

    describe '#date_with_free_doctors' do
      context 'with valid date_time' do
        it 'returns true if there are free doctors with a given date and specialization' do
          doctor = create(:user_doctor)
          reservation = create(
            :reservation, :random_date, doctor_specialization: doctor.specialization
          )
          expect(reservation).to be_valid
        end
      end

      context 'with invalid date_time' do
        it "returns 'There are no free doctors at the given time!' if
          all specialist are busy at the given date" do
          time = Time.new(2017, 10, 10, 18)
          doctor = create(:doctor_with_many_reservations, reservations_count: 1, given_date: time)
          reservation = build(
            :reservation, doctor_specialization: doctor.specialization, date_time: time
          )
          expect(reservation).to_not be_valid
          expect(reservation.errors.messages[:date_time])
            .to eq(['There are no free doctors at the given time!'])
        end
      end
    end
  end
end
