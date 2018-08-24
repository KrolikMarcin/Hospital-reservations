class CreateJoinTableUsersReservations < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :reservations do |t|
      t.index [:user_id, :reservation_id]
    end
  end
end
