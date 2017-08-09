class Wishlist < ActiveRecord::Base
  has_many :products
  belongs_to :user
end
