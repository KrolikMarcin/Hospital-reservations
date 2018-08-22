class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :usersable, polymorphic: true
  has_one :address
  # accepts_nested_attributes_for :patient
  # accepts_nested_attributes_for :employee
  # accepts_nested_attributes_for :address
end
