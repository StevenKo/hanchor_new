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
      " - #{showed_price(coupon.discount_money)}"
    elsif coupon.discount_type == DiscountRule::DISCOUNT_TYPE[1]
      " - #{showed_price((total*coupon.discount_percentage/100).round)}"
    end
  end

  def calculate_total total, coupon, discount
    if coupon.nil?
      total
    else
      if coupon.discount_type == DiscountRule::DISCOUNT_TYPE[2]
        total
      elsif coupon.discount_type == DiscountRule::DISCOUNT_TYPE[0]
        total - coupon.discount_money.to_i
      elsif coupon.discount_type == DiscountRule::DISCOUNT_TYPE[1]
        total - (discount.discount_sum*coupon.discount_percentage/100).round
      end
    end
  end
end