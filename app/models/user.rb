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

  def self.free_doctors(reservation)
    users = where(employee: true, specialization: reservation.doctor_specialization)
            .left_outer_joins(:reservations)
    users = users.where.not(reservations:
      { date_time: reservation.date_time }).or(users.where(reservations: { id: nil }))
    users.group(:id).order('count(reservations.id)')
  end

  # def self.doctors_collection(reservation)
  #   free_doctors(reservation).collect { |user| [user.full_name, user.id] }
  # end

  def self.specializations
    where(employee: true).pluck(:specialization).uniq
  end

  def collection
    [full_name, id]
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
