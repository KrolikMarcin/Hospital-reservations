class AddUserToPrescriptions < ActiveRecord::Migration[5.2]
  def change
    add_reference :prescriptions, :user, foreign_key: true
  end
end
