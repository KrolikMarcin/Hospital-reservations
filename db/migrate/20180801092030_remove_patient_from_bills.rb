class RemovePatientFromBills < ActiveRecord::Migration[5.2]
  def change
    remove_reference :bills, :patient, foreign_key: true
  end
end
