class Bill < ApplicationRecord
  belongs_to :reservation
  belongs_to :user
  has_many :bill_items, dependent: :destroy
  accepts_nested_attributes_for :bill_items, reject_if: :bill_item_empty
  validates :payment_date, :amount, presence: true

  def bill_item_empty(attributes)
    attributes[:description].blank? || attributes[:price].blank?
  end

  def check_paid
    paid ? Time.now : Time.now + 7.days
  end

  def self.not_paid
    where(paid: false).order(payment_date: :desc)
  end

  def self.paid
    where(paid: true).order(payment_date: :desc)
  end

  def check_status
    paid ? 'V' : 'X'
  end
end
