module CartHelper
  
  def sum_cart_items_price items
    sum = 0
    items.each do |item|
      sum += (item.price * item.quantity)
    end
    sum
  end

  def get_cart_item_quantity_selector(item)
    ProductQuantity.where(product_color_id: item.product_color_id, product_size_id: item.product_size_id)[0].quantity_selector
  end

  def cart_item_size
    current_shopping_cart.nil? ? 0 : current_shopping_cart.cart_items.size
  end

  def showed_title coupon
    if ["zh-TW","zh"].include?( params[:locale] )
      coupon.title
    else
      coupon.title_en
    end
  end

  def discount_text coupon, total
    if coupon.discount_type == DiscountRule::DISCOUNT_TYPE[2]
      " + Free Shipping"
    elsif coupon.discount_type == DiscountRule::DISCOUNT_TYPE[0]
      if current_currency.symbol == "NTD"
        " - #{coupon.discount_money}"
      else
        " - #{(coupon.discount_money/current_currency.sell).round(2)}"
      end
    elsif coupon.discount_type == DiscountRule::DISCOUNT_TYPE[1]
      if current_currency.symbol == "NTD"
        " - #{(total*coupon.discount_percentage/100).round}"
      else
        " - #{(total*coupon.discount_percentage/100/current_currency.sell).round(2)}"
      end
    end
  end
end