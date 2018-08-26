class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :role, :employee
  end
end
