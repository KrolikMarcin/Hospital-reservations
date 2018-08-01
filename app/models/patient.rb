class Patient < ApplicationRecord
  has_one :address, as: :addressable
  accepts_nested_attributes_for :address
  belongs_to :user
end
