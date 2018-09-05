class Reservation < ApplicationRecord
  has_and_belongs_to_many :users
  has_one :bill, dependent: :destroy
  has_many :prescriptions, dependent: :destroy
  accepts_nested_attributes_for :prescriptions, reject_if: :prescription_empty
  validate :date_with_free_employees
  before_destroy :check_date

  def prescription_empty(attributes)
    attributes[:medicine].blank? && attributes[:recommendations].blank?
  end

  def date_with_free_employees
    errors.add(:date_time, 'There are no free doctors at the given time!') if
      User.free_employees(self).empty?
  end

  def check_date
    errors.add(:base, 'Is too late for delete reservation!') if
    Time.now.beginning_of_day + 3.days > date_time
    false
  end
  # def free_date_later
  #   while User.free_employees(doctor_specialization, date_time).empty?
  #     date_time += date_time.advance(hours: 1)
  #   end
  #   date_time
  # end

  # def free_date_earlier
  #   while User.free_employees(doctor_specialization, date_time).empty?
  #     date_time -= date_time.advance(hours: 1)
  #   end
  #   date_time
  # end

  # def free_date
  #   { later: free_date_later,
  #     earlier: free_date_earlier }
  # end

  def assign_patient_to_prescriptions
    prescriptions.each do |p|
      p.user = users.find_by(employee: false)
    end
  end

  def remove_doctor_if_exists
    employee = users.where(employee: true)
    users.delete(employee) if employee.exists?
  end

  def date_formated
    date_time.strftime('%a, %d-%m-%Y %H:%M')
  end

  def check_status
    if status
      'V'
    else
      'X'
    end
  end

  def employee
    users.find_by(employee: true)
  end

  def patient
    users.find_by(employee: false)
  end

  def self.today
    where(status: false, date_time: Time.now.all_day)
  end

  def self.status_false
    where(status: false)
  end
end
