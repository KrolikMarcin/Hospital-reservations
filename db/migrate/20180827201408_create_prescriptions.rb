class CreatePrescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :prescriptions do |t|
      t.string :medicine
      t.string :recommendations
      t.references :reservation, foreign_key: true
    end
  end
end
