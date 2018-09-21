class Address < ApplicationRecord
  belongs_to :user
  validates :street, :city, :postal_code, :house_number, presence: true
end
