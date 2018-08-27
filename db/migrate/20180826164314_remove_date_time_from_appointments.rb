class RemoveDateTimeFromAppointments < ActiveRecord::Migration[5.2]
  def change
    remove_column :appointments, :date_time, :datetime
  end
end
