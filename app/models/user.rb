class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :address
  has_and_belongs_to_many :reservations
  accepts_nested_attributes_for :address


#   def self.free_date_later(specialization, date_time)
#     while Employee.employees_without_appointments(
#       specialization, date_time
#     ).empty?
#       date_time += 60 * 30
#     end
#     date_time
#   end

#   def self.free_date_earlier(specialization, date_time)
#     while Employee.employees_without_appointments(
#       specialization, date_time
#     ).empty?
#       date_time -= 60 * 30
#     end
#     date_time
#   end

#   def self.free_date(specialization, date_time)
#     { later: free_date_later(specialization, date_time),
#       earlier: free_date_earlier(specialization, date_time) }
#   end

#   def self.employees_without_appointments(specialization, date_time)
#     busy_employees = joins(:appointments).where(appointments:
#      { date_time: date_time })
#     where(specialization: specialization).where.not(id: busy_employees.ids)
#   end

#   def self.sort_by_appointments(employees, date_time)
#     employees.sort_by do |employee|
#       employee.appointments.where(date_time: date_time.all_day).count
#     end
#   end
# end
end
