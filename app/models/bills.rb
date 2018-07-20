class Bills < ApplicationRecord
  belongs_to :user
  has_many :bill_items
end