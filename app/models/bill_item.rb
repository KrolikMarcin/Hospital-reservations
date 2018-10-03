class BillItem < ApplicationRecord
  belongs_to :bill
  validates :description, :price, presence: true
end
