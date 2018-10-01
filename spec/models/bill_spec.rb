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

  # context '#bill_items_empty(attributes)' do
  #   it 'empty description and nil price' do
  #     allow_any_instance_of(Reservation).to receive(:date_with_free_doctors) { true }
  #     bill = create(:bill, invalid_bill_items: true)
  #     expect(bill.bill_item_empty(bill_item)).to eq(true)
  #   end

  #   # it 'normal bill item' do
  #   #   bill = create(:bill)
  #   #   expect(attributes_for(:bill_item)).to eq('false')
  #   # end
  # end
end