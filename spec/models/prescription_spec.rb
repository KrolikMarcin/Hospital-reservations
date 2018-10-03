require 'rails_helper'

RSpec.describe Prescription, type: :model do
  describe 'validations' do
    subject { build(:prescription) }
    it { is_expected.to validate_presence_of(:medicine) }
    it { is_expected.to validate_presence_of(:recommendations) }
  end
end
