class DiscountRecord < ActiveRecord::Base
  belongs_to :discount_rule
  belongs_to :order
end
