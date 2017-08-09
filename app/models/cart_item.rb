class CartItem < ActiveRecord::Base
  belongs_to :cart
  # has_many :products
  # has_one :product
  belongs_to :product
end
