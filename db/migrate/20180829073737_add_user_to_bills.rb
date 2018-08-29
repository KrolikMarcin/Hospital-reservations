class AddUserToBills < ActiveRecord::Migration[5.2]
  def change
    add_reference :bills, :user, foreign_key: true
  end
end
