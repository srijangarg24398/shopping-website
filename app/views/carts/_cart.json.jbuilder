json.extract! cart, :id, :user_id, :subtotal_price, :total_price, :created_at, :updated_at
json.url cart_url(cart, format: :json)
