class CreatePatients < ActiveRecord::Migration[5.2]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.integer :pesel
      t.boolean :wants_email, default: true
    end
  end
end
