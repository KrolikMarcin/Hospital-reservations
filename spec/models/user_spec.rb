require 'rails_helper'

RSpec.describe User, type: :model do
  it 'full name' do
    user = create :user
    expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
  end

  it 'specializations' do
    doctor1 = create(:user_employee)
    doctor2 = create(:user_employee)
    doctors = User.specializations
    expect(doctors).to eq([doctor1.specialization, doctor2.specialization])
  end
end
