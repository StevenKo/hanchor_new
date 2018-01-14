class DiscountRule < ActiveRecord::Base
  has_many :discount_products
  has_many :discount_records

  DISCOUNT_TYPE = ["percentage", "cash", "free_shipping"]
end
