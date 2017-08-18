class CartItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_pic, optional: true
  belongs_to :product_size, optional: true
  belongs_to :product_color, optional: true
  belongs_to :cart

  validates_presence_of :quantity, :product_id
end
