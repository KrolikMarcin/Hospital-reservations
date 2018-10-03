require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    subject { build(:address) }
    it { is_expected.to validate_presence_of(:street) }
    it { is_expected.to validate_presence_of(:postal_code) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:house_number) }
  end
end
