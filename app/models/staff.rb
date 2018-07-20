class Staff < ApplicationController
  has_one :address, as: :addressable
  has_and_belongs_to_many :appointments
end