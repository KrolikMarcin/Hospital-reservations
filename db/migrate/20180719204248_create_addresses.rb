class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :house_number
      t.string :apartment_number
      t.string :postal_code
      t.string :city
      t.references :user, foreign_key: true
    end
  end
end
