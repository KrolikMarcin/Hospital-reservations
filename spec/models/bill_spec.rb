require 'rails_helper'

RSpec.describe Bill, type: :model do
  before do
    allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
  end
  context '#check_status' do
    it 'returns V if paid: true' do
      bill = build(:bill)
      expect(bill.check_status).to eq('V')
    end

    it 'returns X if paid: false' do
      bill = build(:bill, :paid_false)
      expect(bill.check_status).to eq('X')
    end
  end

  context '#check_paid' do
    it 'returns current date and time if paid: true' do
      bill = build(:bill)
      expect(bill.check_paid).equal?((Time.now - 5.second)..Time.now)
    end

    it 'returns current date + 7 days if paid: false' do
      bill = build(:bill, :paid_false)
      time = Time.now
      expect(bill.check_status).equal?(time + 7.day..Time.now + 7.day)
    end
  end

  context '#bill_item_empty(attributes)' do
    it 'returns true if bill item attributes are empty or nil' do
      bill = create(:bill)
      expect(bill.bill_item_empty(attributes_for(:bill_item_empty))).to be true
    end

    it 'returns false if bill item attributes are not empty' do
      bill = create(:bill)
      expect(bill.bill_item_empty(attributes_for(:bill_item))).to be false
    end

    it 'returns true if one bill item attribute is empty and second is no empty' do
      bill = create(:bill)
      expect(bill.bill_item_empty(attributes_for(:bill_item, price: nil))).to be true
    end
  end
end