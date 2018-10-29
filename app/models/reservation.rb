class Reservation < ApplicationRecord
  has_and_belongs_to_many :users
  has_one :bill, dependent: :destroy
  has_many :prescriptions, dependent: :destroy
  accepts_nested_attributes_for :prescriptions, reject_if: :prescription_empty
  validate :date_with_free_doctors, :outdated_date, if: :date_changed?
  validates :doctor_specialization, :symptoms, presence: true
  before_destroy :check_date
  before_destroy :check_bill, if: :bill_exists?
  before_update :check_date

  def self.chosen_day(date)
    where(date_time: date.all_day)
  end

  def self.user_reservations(user)
    joins(:users).where(users: { id: user.id })
  end

  def assign_patient_to_prescriptions
    prescriptions.each { |p| p.user = doctor }
  end

  def remove_doctor_if_exists
    users.delete(doctor) if doctor.exists?
  end

  def hour_formated
    date_time.strftime('%H:%M')
  end

  def date_formated
    date_time.strftime('%a, %d-%m-%Y %H:%M')
  end

  def check_status
    status ? 'V' : 'X'
  end

  def doctor
    users.find_by(role: 'doctor')
  end

  def patient
    users.find_by(role: 'patient')
  end

  # need for the simple calendar
  def start_time
    date_time
  end

  private

  def prescription_empty(attributes)
    attributes[:medicine].blank? && attributes[:recommendations].blank?
  end

  def date_changed?
    date_time_changed?
  end

  def date_with_free_doctors
    errors.add(:date_time, 'There are no free doctors at the given time!') if
      User.free_doctors(self).empty?
  end

  def outdated_date
    errors.add(:date_time, "You can't chose outdated date") if date_time < Time.now
  end

  def check_date
    if Time.now + 1.day > date_time && !status
      errors.add(:base, 'Is too late for delete and edit reservation!')
      throw(:abort)
    end
  end

  def bill_exists?
    !bill.nil?
  end

  def check_bill
    errors.add(:base, "You can't delete a reservation becouse patient has unpaid bill") unless
      bill.paid
  end
end
