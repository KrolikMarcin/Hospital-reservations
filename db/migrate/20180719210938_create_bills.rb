class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.decimal :price
      t.date :payment_date
      t.boolean :payment_status
      t.references :user, foreign_key: true
    end
  end
end
