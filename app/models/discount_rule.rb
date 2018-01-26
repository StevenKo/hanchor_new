class DiscountRule < ActiveRecord::Base
  has_many :discount_products
  has_many :discount_records

  DISCOUNT_TYPE = ["cash", "free_shipping"]

  scope :active, -> { where("? >= start_date AND ? < end_date", Time.now, Time.now) }

  def discount_text
  	if discount_type == DISCOUNT_TYPE[1]
  		" + Free Shipping"
  	else
  		" - #{discount_money}"
  	end
  end

end
