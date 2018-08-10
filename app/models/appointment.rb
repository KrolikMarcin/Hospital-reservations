class Appointment < ApplicationRecord
  belongs_to :reservation
  has_and_belongs_to_many :employees
  has_one :bill, dependent: :destroy
end
