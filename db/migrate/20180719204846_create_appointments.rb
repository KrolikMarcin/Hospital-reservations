class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.datetime :date_time
      t.boolean :nurse_help
      t.references :reservation
    end
  end
end
