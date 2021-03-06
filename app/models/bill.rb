class Bill < ApplicationRecord
  belongs_to :reservation
  belongs_to :user
  has_many :bill_items, dependent: :destroy
  accepts_nested_attributes_for :bill_items, reject_if: :bill_item_empty
  validates :payment_date, :amount, presence: true
  validate :bill_items_empty

  def bill_item_empty(attributes)
    attributes[:description].blank? || attributes[:price].blank?
  end

  def check_paid
    paid ? Time.now : Time.now + 7.days
  end

  def check_status
    paid ? 'V' : 'X'
  end

  def bill_items_empty
    errors.add(:bill_items, "You don't added any to bill items") if bill_items.empty?
  end
end
