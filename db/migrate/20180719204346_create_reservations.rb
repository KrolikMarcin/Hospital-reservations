class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.datetime :date_time
      t.string :doctor_specialization
      t.string :symptoms
      t.references :user
    end
  end
end
