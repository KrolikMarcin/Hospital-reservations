class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.decimal :amount
      t.date :payment_date
      t.boolean :paid, default: false
      t.references :reservation, foreign_key: true
    end
  end
end
