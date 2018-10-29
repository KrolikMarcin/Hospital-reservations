class ChangeColumnNameUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :roles, :role
  end
end
