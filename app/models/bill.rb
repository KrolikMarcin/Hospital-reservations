class Bill < ApplicationRecord
  belongs_to :appointment
  has_many :bill_items, dependent: :destroy
  accepts_nested_attributes_for :bill_items, reject_if: :bill_item_empty

  def bill_item_empty(attributes)
    attributes[:description].blank? && attributes[:price].blank?
  end

  def check_date
    if payment_status
      Time.now
    else
      Time.now + 7.days
    end
  end
end
