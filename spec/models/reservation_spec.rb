require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context '.chosen_day' do
    it 'returns reservations from a given day' do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      reservations = create_list(:reservation, 3)
      create_list(:reservation, 3, :random_date)
      expect(Reservation.chosen_day(reservations.first.date_time)).to eq(reservations)
    end
  end

  context '.user_reservations' do
    it 'returns all reservations for given user' do
      doctors = create_list(:doctor_with_many_reservations, 3, random_date: true)
      expect(Reservation.user_reservations(doctors.first)).to eq(doctors.first.reservations)
    end
  end

  context '#remove_doctor_if_exists' do
    before do
      @doctor = create(:user_doctor)
      @reservation = create(:reservation, doctor_specialization: @doctor.specialization)
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
      @reservation = create(:reservation_with_chosen_doctor)
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
    subject { build(:reservation) }
    it { is_expected.to validate_presence_of(:doctor_specialization) }
    it { is_expected.to validate_presence_of(:symptoms) }

    describe 'date_time validations' do
      context 'with valid date_time' do
        it 'returns true if there are free doctors with a given date and specialization
          and chosen date is current' do
          doctor = create(:user_doctor)
          reservation = create(
            :reservation, :random_date, doctor_specialization: doctor.specialization
          )
          expect(reservation).to be_valid
        end
      end

      context 'with invalid date_time' do
        it "returns errors: 'There are no free doctors at the given time!' and
          'You can't chose outdated date' if all specialist are busy at the given date and
          chosen date is outdated" do
          reservation = build(:reservation, date_time: Time.new(2016, 10, 10, 18))
          expect(reservation).to_not be_valid
          expect(reservation.errors.messages[:date_time])
            .to include(
              'There are no free doctors at the given time!', "You can't chose outdated date"
            )
        end
      end
    end
  end
end
