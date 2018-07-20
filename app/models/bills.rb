class Bills < ApplicationRecord
  belongs_to :patient
  has_many :bill_items
end