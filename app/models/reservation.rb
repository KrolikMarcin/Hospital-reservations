class Reservation < ApplicationRecord
  has_and_belongs_to_many :users
  has_one :bill, dependent: :destroy
  has_many :prescriptions, dependent: :destroy
  accepts_nested_attributes_for :prescriptions, reject_if: :prescription_empty
  validate :date_with_free_doctors, :current_date
  before_destroy :check_date
  validates :doctor_specialization, presence: true

  def self.today_all_reservations
    where(status: false, date_time: Time.now.all_day).order(date_time: :desc)
  end

  def self.doctor_today_reservations(employee)
    where(date_time: Time.now.all_day).joins(:users)
                                      .where(users: { id: employee.id })
                                      .order(date_time: :desc)
  end

  def self.doctor_week_reservations(employee)
    where(date_time: Time.now.all_week).joins(:users)
                                       .where(users: { id: employee.id })
                                       .order(date_time: :desc)
  end

  def self.doctor_month_reservations(employee)
    where(date_time: Time.now.all_month).joins(:users)
                                        .where(users: { id: employee.id })
                                        .order(date_time: :desc)
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
    prescriptions.each { |p| p.user = users.find_by(employee: false) }
  end

  def remove_doctor_if_exists
    employee = users.where(employee: true)
    users.delete(employee) if employee.exists?
  end

  def date_formated
    date_time.strftime('%a, %d-%m-%Y %H:%M')
  end

  def check_status
    status ? 'V' : 'X'
  end

  def employee
    users.find_by(employee: true)
  end

  def patient
    users.find_by(employee: false)
  end
end
