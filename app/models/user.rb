class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :address
  has_many :bills
  has_many :prescriptions
  has_and_belongs_to_many :reservations

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.free_employees(specialization, date_time)
    where(employee: true, specialization: specialization)
      .joins(:reservations).where.not(reservations: { date_time: date_time })
      .uniq.sort_by do |employee|
        employee.reservations.where(date_time: date_time.all_day).count
      end
  end

  def self.specializations
    where(employee: true).pluck(:specialization).uniq
  end
end
