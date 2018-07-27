class CreateBillItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_items do |t|
      t.references :bill
      t.string :description
      t.decimal :price
    end
  end
end
