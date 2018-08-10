class Reservation < ApplicationRecord
  has_one :appointment, dependent: :destroy
  belongs_to :user
end
