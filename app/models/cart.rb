class Cart < ActiveRecord::Base
  belongs_to :user, optional: true
  has_many :cart_items

  def paypal_url(return_url,locale,notify_url,order_id,shipping_cost)
    values = {
      :business => 'JQP4PTRJQ8KHY',
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => order_id,
      :lc => locale,
      :currency_code => "TWD",
      :notify_url => notify_url,
      :charset => 'utf-8'
    }
    order = Order.find(order_id)
    values.merge!({
      "amount_1" => order.total,
      "item_name_1" => "Total Price",
      "quantity_1" => 1
    })
    "https://www.paypal.com/cgi-bin/webscr?" + values.to_query
  end


  def calculate_coupon discount_rule_id
    coupon = DiscountRule.find(discount_rule_id)
    return CouponMessage.new(false,[],true,false,0) unless coupon.is_valid
    discount_products_ids = coupon.discount_products.map{|p| p.product_id}
    suitable_products = []
    sum = 0
    discount_sum = 0
    cart_items.each do |item|
      sum += (item.price * item.quantity)
      if discount_products_ids.include? item.product_id
        suitable_products << item.product_id
        discount_sum += (item.price * item.quantity)
      end
    end
    if suitable_products.present?
      if sum >= coupon.threshold
        return CouponMessage.new(true,suitable_products,false,false,discount_sum)
      else
        return CouponMessage.new(false,suitable_products,false,true,discount_sum)
      end
    else
      return CouponMessage.new(false,[],false,false,discount_sum)
    end
  end

  class CouponMessage
    attr_accessor :is_valid, :suitable_products, :is_expired, :is_less_than_threshold, :discount_sum

    def initialize(is_valid, suitable_products, is_expired, is_less_than_threshold, discount_sum)
      @is_valid = is_valid
      @suitable_products = suitable_products
      @is_expired = is_expired
      @is_less_than_threshold = is_less_than_threshold
      @discount_sum = discount_sum
    end
  end

end
