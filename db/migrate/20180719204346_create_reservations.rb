class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.date :reservation_date
      t.string :preferred_hour
      t.string :doctors_specializations
      t.references :user, foreign_key: true
    end
  end
end
