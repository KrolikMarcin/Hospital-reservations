class Patient < ApplicationRecord
  has_one :user, as: :userable
  has_many :reservations
  accepts_nested_attributes_for :address
end
