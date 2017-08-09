class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :cart_items

  def self.calculate_sub_total_price cart_id
  	new_sub_total_price=0
  	# byebug
  	cart=Cart.find(cart_id)
  	cart.cart_items.each do |cart_item|
  		puts "khd"
  		new_sub_total_price=new_sub_total_price+cart_item.total_price_item
  	end
  	return new_sub_total_price
  end
  def self.new_subtotal_price current_cart
  	subtotal_price=calculate_sub_total_price(current_cart.id)
  	total_price=subtotal_price
  	newcrt={subtotal_price:subtotal_price,total_price:total_price}
  	current_cart.update(newcrt)
  end
end
