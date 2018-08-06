class AddStatusToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :status, :boolean, default: false
  end
end
