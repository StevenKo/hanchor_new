class DiscountRule < ActiveRecord::Base
  has_many :discount_products
  has_many :discount_records

  DISCOUNT_TYPE = ["cash", "percentage", "free_shipping"]

  scope :active, -> { where("? >= start_date AND ? < end_date", Time.now, Time.now) }

  def discount_text
  	if discount_type == DISCOUNT_TYPE[2]
  		" + Free Shipping"
  	elsif discount_type == DISCOUNT_TYPE[0]
  		" - #{discount_money}"
    elsif
      "gg了"
  	end
  end

end
