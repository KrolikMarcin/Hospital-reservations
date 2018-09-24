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
    users = where(employee: true, specialization: reservation.doctor_specialization)
            .left_outer_joins(:reservations)
    users = users.where.not(reservations:
      { date_time: reservation.date_time }).or(users.where(reservations: { id: nil }))
    users.group(:id).order('COUNT(reservations.id)')
  end

  def self.specializations
    where(employee: true).pluck(:specialization).uniq
  end
end
