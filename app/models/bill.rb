class Bill < ApplicationRecord
  belongs_to :appointment
  has_many :bill_items
end
