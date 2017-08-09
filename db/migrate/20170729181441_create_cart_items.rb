class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.references :cart, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :item_quantity
      t.float :total_price_item

      t.timestamps null: false
    end
  end
end
