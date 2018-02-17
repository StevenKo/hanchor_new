class DiscountRule < ActiveRecord::Base
  has_many :discount_products
  has_many :discount_records

  DISCOUNT_TYPE = ["cash", "percentage", "free_shipping"]

  scope :active, -> { where("? >= start_date AND ? < end_date", Time.now, Time.now) }

end
