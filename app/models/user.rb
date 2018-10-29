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
  before_save :titleize_full_name
  before_save :spiecialization_empty
  before_destroy :check_bills

  def self.clinic_specializations
    ['psychiatrist', 'gynecologist', 'dentist', 'orthopaedist', 'surgeon', 'psychologist',
     'laryngologist', 'pediatrist', 'dermatologist'].sort
  end

  def self.free_doctors(reservation)
    specialists = doctors.where(specialization: reservation.doctor_specialization)
    busy_pecialists = specialists.joins(:reservations)
                              .where(reservations: { date_time: reservation.date_time }).pluck(:id)
    # returns sorted free doctors
    specialists.joins(:reservations).where.not(id: busy_specialists)
               .group(:id).order(Arel.sql('count(reservations.id)'))
  end

  def self.specializations
    doctors.pluck(:specialization).uniq
  end

  def self.doctors_with_reservations_in_chosen_day(date)
    doctors.includes(:reservations).where(reservations: { date_time: date.all_day })
           .order(:specialization, :last_name)
  end

  def self.doctors
    where(role: 'doctor').order(:specialization)
  end

  def self.patients
    where(role: 'patient').order(:last_name)
  end

  def self.admins
    where(role: 'admin').order(:last_name)
  end

  def collection
    [full_name, id]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    role == 'admin'
  end

  def patient?
    role == 'patient'
  end

  def doctor?
    role == 'doctor'
  end

  private

  def titleize_full_name
    write_attribute(:first_name, first_name.titleize)
    write_attribute(:last_name, last_name.titleize)
  end

  def spiecialization_empty
    write_attribute(:specialization, nil) if patient?
  end

  def check_bills
    if bills.where(paid: false).exists?
      errors.add(:base, "You can't delete user, becouse has unpaid bills")
      throw(:abort)
    end
  end
end
