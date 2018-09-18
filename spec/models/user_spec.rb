require 'rails_helper'

RSpec.describe User, type: :model do
  it 'full name' do
    user = FactoryBot.create :user
    expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
  end

  it 'specializations' do
    doctor1 = FactoryBot.create(:user, :employee)
    doctor2 = FactoryBot.create(:user, :employee)
    doctors = User.specializations
    expect(doctors).to eq([doctor1.specialization, doctor2.specialization])
  end

  # it 'free employees' do
  #   doctors = FactoryBot.create_list(
  #     :user, 25, specialization: 'psychiatrist', employee: true
  #   )
  #   reservation = Reservation.create!(
  #     date_time: Time.now,
  #     doctor_specialization: 'psychiatrist'
  #   )
  #   free_doctors = User.free_employees(reservation)
  #   # expect(free_doctors).eq(doctors)
  #   pry binding
  #   free_doctors.should match_array(doctors)
  # end
end
