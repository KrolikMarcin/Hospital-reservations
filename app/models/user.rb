class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :address
  has_many :bills
  has_many :prescriptions
  has_and_belongs_to_many :reservations
  validates :first_name, :last_name, presence: true, length: { in: 3..20 }
  validates :pesel, presence: true, numericality: { equel_to: 9 }

  def self.free_doctors(reservation)
    doctors = where(roles: 'doctor', specialization: reservation.doctor_specialization)
              .left_outer_joins(:reservations)
    busy_doctors = doctors.where(reservations: { date_time: reservation.date_time }).pluck(:id)
    # returns sorted free doctors
    doctors.where.not(id: busy_doctors).group(:id).order(Arel.sql('count(reservations.id)'))
  end

  def self.specializations
    where(roles: 'doctor').pluck(:specialization).uniq
  end

  def collection
    [full_name, id]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin
    true if roles == 'admin'
  end

  def patient
    true if roles == 'patient'
  end

  def doctor
    true if roles == 'doctor'
  end
end
