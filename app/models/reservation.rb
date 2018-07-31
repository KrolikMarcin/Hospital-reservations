class Reservation < ApplicationRecord
  has_one :appointment
  belongs_to :user
end
