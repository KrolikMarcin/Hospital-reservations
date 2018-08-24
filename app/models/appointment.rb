class Appointment < ApplicationRecord
  belongs_to :reservation
  has_one :bill, dependent: :destroy
end
