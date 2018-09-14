class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :address
  has_many :bills
  has_many :prescriptions
  has_and_belongs_to_many :reservations
  validates :first_name, :last_name, presence: true, length: { in: 3..15 }
  validates :pesel, presence: true, numericality: { equel_to: 9 }

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.free_employees(reservation)
    where(employee: true, specialization: reservation.doctor_specialization)
      .joins(:reservations).where.not(reservations:
        { date_time: reservation.date_time }).uniq
  end

  def self.sorted_free_employees(reservation)
    free_employees(reservation).sort_by do |employee|
      employee.reservations.where(date_time: reservation.date_time.all_day)
              .count
    end.collect { |doctor| [doctor.full_name, doctor.id] }
  end

  def self.specializations
    where(employee: true).pluck(:specialization).uniq
  end
end
