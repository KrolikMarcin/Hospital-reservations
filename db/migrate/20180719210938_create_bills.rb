class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.decimal :amount
      t.date :payment_date
      t.boolean :payment_status, default: false
      t.references :patient, foreign_key: true
    end
  end
end
