class Appointment < ApplicationRecord
  belongs_to :reservation
  has_one :bill, dependent: :destroy
  accepts_nested_attributes_for :bill
end
