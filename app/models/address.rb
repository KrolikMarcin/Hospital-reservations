class Address < ApplicationRecord
  belongs_to :user
  validates :street, :city, :postal_code, :house_number, presence: true

  def capitalize_attributes
    write_attribute(:street, street.capitalize)
    write_attribute(:city, city.capitalize)
  end
end
