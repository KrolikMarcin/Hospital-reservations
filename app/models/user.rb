class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :address
  has_many :bills
  has_many :prescriptions
  has_and_belongs_to_many :reservations, dependent: :destroy 
  validates :first_name, :last_name, presence: true, length: { in: 3..20 }
  validates :pesel, presence: true, numericality: { equel_to: 9 }

  def self.free_doctors(reservation)
    doctors = where(roles: 'doctor', specialization: reservation.doctor_specialization)
    busy_doctors = doctors.left_outer_joins(:reservations)
                          .where(reservations: { date_time: reservation.date_time }).pluck(:id)
    # returns sorted free doctors
    doctors.left_outer_joins(:reservations).where.not(id: busy_doctors)
           .group(:id).order(Arel.sql('count(reservations.id)'))
  end

  def self.specializations
    where(roles: 'doctor').pluck(:specialization).uniq
  end

  def self.doctors_with_reservations_in_chosen_day(date)
    User.where(roles: 'doctor').includes(:reservations)
        .where(reservations: { date_time: date.all_day }).order(:specialization, :last_name)
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
