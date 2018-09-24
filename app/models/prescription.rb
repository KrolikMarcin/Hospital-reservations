class Prescription < ApplicationRecord
  belongs_to :reservation
  belongs_to :user
  validates :medicine, presence: true
end