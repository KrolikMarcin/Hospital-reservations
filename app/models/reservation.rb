class Reservation < ApplicationRecord
  has_and_belongs_to_many :users
  has_one :bill, dependent: :destroy
  has_many :prescriptions, dependent: :destroy
  accepts_nested_attributes_for :prescriptions, reject_if: :prescription_empty
  validate :date_with_free_doctors, :current_date, if: :date_changed?
  before_destroy :check_date
  validates :doctor_specialization, :symptoms, presence: true

  def self.chosen_day(date)
    where(date_time: date.all_day)
  end

  def self.user_reservations(user)
    joins(:users).where(users: { id: user.id })
  end

  def prescription_empty(attributes)
    attributes[:medicine].blank? && attributes[:recommendations].blank?
  end

  def date_with_free_doctors
    errors.add(:date_time, 'There are no free doctors at the given time!') if
      User.free_doctors(self).empty?
  end

  def current_date
    errors.add(:date_time, "You can't chose outdated date") if date_time < Time.now
  end

  def check_date
    errors.add(:base, 'Is too late for delete reservation!') if
    Time.now.beginning_of_day + 3.days > date_time
    false
  end

  def assign_patient_to_prescriptions
    prescriptions.each { |p| p.user = users.find_by(roles: 'patient') }
  end

  def remove_doctor_if_exists
    doctor = users.where(roles: 'doctor')
    users.delete(doctor) if doctor.exists?
  end

  def date_formated
    date_time.strftime('%a, %d-%m-%Y %H:%M')
  end

  def date_changed?
    date_time_changed?
  end

  def check_status
    status ? 'V' : 'X'
  end

  def doctor
    users.find_by(roles: 'doctor')
  end

  def patient
    users.find_by(roles: 'patient')
  end

  def start_time
    date_time
  end
end
