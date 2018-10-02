require 'rails_helper'

RSpec.describe User, type: :model do
  context '.specializations' do
    it 'returns unique specializations' do
      doctors = create_list(:user_doctor, 4, :random_specialization)
      expect(User.specializations).to eq(doctors.map(&:specialization).uniq)
    end
  end

  context '.free_employees' do
    before do
      allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
      @reservation = create(:reservation_with_patient)
      @busy_doctors = create_list(:doctor_with_many_reservations, 3,
                                  reservations_count: 1,
                                  specialization: @reservation.doctor_specialization,
                                  given_date: @reservation.date_time)
    end
    it 'returns only free doctors with the given date and the given specialization' do
      doctors = create_list(:doctor_with_many_reservations, 3,
                            specialization: @reservation.doctor_specialization, random_date: true)
      expect(User.free_doctors(@reservation)).to eq(doctors)
    end

    it 'returns empty array if all doctors with the given date and specialization are busy' do
      expect(User.free_doctors(@reservation)).to eq([])
    end

    it 'returns free doctors if doctors do not have any reservations' do
      doctors = create_list(:user_doctor, 3, specialization: @reservation.doctor_specialization)
      expect(User.free_doctors(@reservation)).to eq(doctors)
    end

    it 'returns empty array if chosen specialist are busy, but other doctors are free' do
      create_list(:user_doctor, 5, :random_specialization)
      expect(User.free_doctors(@reservation)).to eq([])
    end
  end

  context '#full name' do
    it 'returns concatenated first and last name' do
      user = create(:user)
      expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
    end
  end

  context '#collection' do
    it 'returns collection with full name and id' do
      user = create(:user)
      expect(user.collection).to eq([user.full_name, user.id])
    end
  end
end
