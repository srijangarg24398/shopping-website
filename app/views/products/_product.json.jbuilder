json.extract! product, :id, :category_id, :product_name, :product_cost, :product_quantity, :product_image, :product_description, :seller_id, :created_at, :updated_at
json.url product_url(product, format: :json)
