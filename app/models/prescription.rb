class Prescription < ApplicationRecord
  belongs_to :reservation
  belongs_to :user
end