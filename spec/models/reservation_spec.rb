require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context 'remove_doctor_if_exists' do
    before do
      @user = FactoryBot.create :user
      @reservation = FactoryBot.create :reservation
      @reservation.users << @user
    end
    it 'without existing doctor' do
      @reservation.remove_doctor_if_exists
      expect(@reservation.users).to eq([@user])
    end
    it 'with existing doctor' do
      doctor = FactoryBot.create(:user, :employee)
      @reservation.users << doctor
      @reservation.remove_doctor_if_exists
      expect(@reservation.users).to eq([@user])
    end
  end
end
