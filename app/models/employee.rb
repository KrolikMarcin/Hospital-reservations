class Employee < ApplicationRecord
  has_one :address, as: :addressable
  has_and_belongs_to_many :appointments

  def full_name
    ["#{first_name} #{last_name}", id]
  end

  def self.employees_without_appointments(specialization, date_time)
    busy_employees = joins(:appointments).where(appointments:
     { date_time: date_time })
    where(specialization: specialization).where.not(id: busy_employees.ids)
  end

  def self.sort_by_appointments(employees, date_time)
    employees.sort_by do |employee|
      employee.appointments.where(date_time: date_time.all_day).count
    end
  end
end
