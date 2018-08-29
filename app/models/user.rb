class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :address
  has_many :bills
  has_and_belongs_to_many :reservations

  def full_name
    ["#{first_name} #{last_name}", id]
  end

  def self.free_date_later(specialization, date_time)
    while User.employees_without_appointments(
      specialization, date_time
    ).empty?
      date_time += 60 * 30
    end
    date_time
  end

  def self.free_date_earlier(specialization, date_time)
    while User.employees_without_appointments(
      specialization, date_time
    ).empty?
      date_time -= 60 * 30
    end
    date_time
  end

  def self.free_date(specialization, date_time)
    { later: free_date_later(specialization, date_time),
      earlier: free_date_earlier(specialization, date_time) }
  end

  def self.free_employees(specialization, date_time)
    busy_employees = joins(:reservations)
                     .where(reservations: { date_time: date_time })
    where(employee: true, specialization: specialization)
      .where.not(id: busy_employees.ids)
  end

  def self.sort_by_appointments(employees, date_time)
    employees.sort_by do |employee|
      employee.reservations.where(date_time: date_time.all_day).count
    end
  end
end
