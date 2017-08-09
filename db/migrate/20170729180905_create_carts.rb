class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.references :user, index: true, foreign_key: true
      t.float :subtotal_price
      t.float :total_price

      t.timestamps null: false
    end
  end
end
