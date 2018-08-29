class Bill < ApplicationRecord
  belongs_to :reservation
  belongs_to :user
  has_many :bill_items, dependent: :destroy
  accepts_nested_attributes_for :bill_items, reject_if: :bill_item_empty

  def bill_item_empty(attributes)
    attributes[:description].blank? && attributes[:price].blank?
  end

  def check_date
    paid ? Time.now : Time.now + 7.days
  end
end
