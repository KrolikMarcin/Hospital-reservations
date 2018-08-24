class Reservation < ApplicationRecord
  has_one :appointment, dependent: :destroy
  has_and_belongs_to_many :users
end
