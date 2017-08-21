class RecommendShip < ActiveRecord::Base
  belongs_to :product, :class_name => 'Product'
  belongs_to :recommend, :class_name => 'Product'
end
