class Bill < ApplicationRecord
  belongs_to :appointment
  has_many :bill_items
  accepts_nested_attributes_for :bill_items
end
