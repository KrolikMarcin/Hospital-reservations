class Appointment < ApplicationRecord
  belongs_to :reservation
  has_and_belongs_to_many :staffs
end