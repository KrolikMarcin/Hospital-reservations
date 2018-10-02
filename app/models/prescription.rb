class Prescription < ApplicationRecord
  belongs_to :reservation
  belongs_to :user
  validates :medicine, :recommendations, presence: true
end