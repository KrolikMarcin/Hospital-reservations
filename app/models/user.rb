class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :userable, polymorphic: true, optional: true
  has_one :address
  accepts_nested_attributes_for :address
  # before_validation :type
  # def type
  #   if role
  #     employee = Employee.create
  #     self.userable = employee
  #   else
  #     patient = Patient.create
  #     self.userable = patient
  #   end
  # end
end
