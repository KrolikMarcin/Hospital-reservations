class AddReferencesToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :doctor_specialization, :string
  end
end
