class ProductCategoryShip < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_category
end
