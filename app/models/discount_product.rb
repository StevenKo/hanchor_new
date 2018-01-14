class DiscountProduct < ActiveRecord::Base
  belongs_to :discount_rule
  belongs_to :product
end
