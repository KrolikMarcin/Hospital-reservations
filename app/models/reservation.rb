class Reservation < ApplicationRecord
  has_and_belongs_to_many :users
  has_one :bill, dependent: :destroy
  has_many :prescriptions, dependent: :destroy
  accepts_nested_attributes_for :prescriptions, reject_if: :prescription_empty
  validate :date_with_free_employees

  def prescription_empty(attributes)
    attributes[:medicine].blank? && attributes[:recommendations].blank?
  end

  def date_with_free_employees
    if User.free_employees(doctor_specialization, date_time).empty?
      errors.add(:date_time, "There are no free doctors at the given time!")
    end
  end

  def free_date_later
    while User.free_employees(
      doctor_specialization, date_time
    ).empty?
      date_time += date_time.advance(hours: 1)
    end
    date_time
  end

  def free_date_earlier
    while User.free_employees(
      doctor_specialization, date_time
    ).empty?
      date_time -= date_time.advance(hours: 1)
    end
    date_time
  end

  def free_date
    { later: free_date_later,
      earlier: free_date_earlier }
  end

  def assign_patient_to_prescriptions
    pry binding
    prescriptions.each do |p|
      p.user = users.find_by(employee: false)
    end
  end
end
