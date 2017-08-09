json.extract! cart_item, :id, :cart_id, :product_id, :item_quantity, :total_price_item, :created_at, :updated_at
json.url cart_item_url(cart_item, format: :json)
