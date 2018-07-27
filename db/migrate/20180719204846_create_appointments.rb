class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.date :appointment_date
      t.string :appointment_hour
      t.string :appointment_staff
      t.references :reservation
    end
  end
end
