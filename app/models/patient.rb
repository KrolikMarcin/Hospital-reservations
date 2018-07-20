class Patient < ApplicationRecord
  has_one :address, as: :addressable
  has_many :bills
  accepts_nested_attributes_for :address, allow_destroy: true
  belongs_to :user, foreign_key: true
end