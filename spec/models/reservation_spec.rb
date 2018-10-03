require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context '.today_all_reservations' do
    it 'returns reservations only from today' do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      today_reservations = create_list(:reservation, 5, date_time: Time.now + 1.hour)
      create_list(:reservation, 3, date_time: Time.now + 5.days)
      expect(Reservation.today_all_reservations).to eq(today_reservations)
    end
  end

  context '.doctor_today_reservations(employee)' do
    it "returns only today's reservations for the given doctor" do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      doctor = create(:user_doctor)
      todays_reservations = create_list(
        :reservation, 3, doctor_specialization: doctor.specialization, date_time: Time.now + 1.hour
      )
      not_todays_reservations = create_list(
        :reservation, 4, doctor_specialization: doctor.specialization, date_time: Time.now + 10.days
      )
      doctor.reservations << [todays_reservations, not_todays_reservations]
      create(:doctor_with_many_reservations, reservations_count: 5, random_date: true)
      expect(Reservation.doctor_today_reservations(doctor)).to eq(todays_reservations)
    end
  end

  context '.doctor_week_reservations(employee)' do
    it 'returns reservations only from this week for the given doctor' do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      doctor = create(:user_doctor)
      reservations_from_this_week = create_list(
        :reservation, 3, doctor_specialization: doctor.specialization, date_time: Time.now + 1.hour
      )
      reservations_from_other_week = create_list(
        :reservation, 4, doctor_specialization: doctor.specialization, date_time: Time.now + 30.days
      )
      doctor.reservations << [reservations_from_this_week, reservations_from_other_week]
      create(:doctor_with_many_reservations, reservations_count: 5, random_date: true)
      expect(Reservation.doctor_today_reservations(doctor)).to eq(reservations_from_this_week)
    end
  end

  context '.doctor_month_reservations(employee)' do
    it 'returns reservations only from this month for the given doctor' do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      doctor = create(:user_doctor)
      reservations_from_this_month = create_list(
        :reservation, 3, doctor_specialization: doctor.specialization, date_time: Time.now + 1.hour
      )
      reservations_from_other_month = create_list(
        :reservation, 4, doctor_specialization: doctor.specialization, date_time: Time.now + 80.days
      )
      doctor.reservations << [reservations_from_this_month, reservations_from_other_month]
      create(:doctor_with_many_reservations, reservations_count: 5, random_date: true)
      expect(Reservation.doctor_today_reservations(doctor)).to eq(reservations_from_this_month)
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
            .to eq(
              ['There are no free doctors at the given time!', "You can't chose outdated date"]
            )
        end
      end
    end
  end
end
