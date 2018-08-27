class Appointment < ApplicationRecord
  belongs_to :reservation
  has_one :bill, dependent: :destroy
  has_many :prescriptions, dependent: :destroy
  accepts_nested_attributes_for :prescriptions, reject_if: :prescription_empty

  def prescription_empty(attributes)
    attributes[:medicine].blank? && attributes[:recommendations].blank?
  end
end
