class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.datetime :date_time
      t.string :diagnosis
      t.references :reservation, foreign_key: true
    end
  end
end
