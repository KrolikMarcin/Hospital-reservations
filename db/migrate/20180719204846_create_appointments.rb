class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.date :appointment_date
      t.string :appointment_hour
      t.string :appointment_staffs
      t.references :reservation, foreign_key: true
    end
  end
end
