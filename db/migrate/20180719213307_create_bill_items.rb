class CreateBillItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_items do |t|
      t.references :bill, foreign_key: true
      t.string :description
      t.decimal :price
    end
  end
end
