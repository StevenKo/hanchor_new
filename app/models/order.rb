# encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :shipping_cost
  has_many :order_items
  validates_presence_of :shipping_cost_id
  has_one :discount_record

  attr_accessor :store_code, :store_name
  validates_presence_of :store_code, :store_name

  scope :showed, -> {where(is_show: true)}

  def dose_not_have_product_in_stock
    order_items.each do |item|
      q = ProductQuantity.find_by(product_id: item.product_id, product_color_id: item.product_color_id, product_size_id: item.product_size_id)
      return true if item.quantity > q.quantity
    end
    false
  end

  def quantity_error_mesage country_id
    no_stock_items = []

    order_items.each do |item|
      q = ProductQuantity.find_by(product_id: item.product_id, product_color_id: item.product_color_id, product_size_id: item.product_size_id)
      no_stock_items << item.product.product_infos.find_by(country_id: country_id) if item.quantity > q.quantity
    end
    "抱歉目前 [#{no_stock_items.map(&:name).join(',')}] 沒有這麼多庫存"
  end

  def deduct_quanitity

    order_items.each do |item|
      q = ProductQuantity.find_by(product_id: item.product_id, product_color_id: item.product_color_id, product_size_id: item.product_size_id)
      q.update_attribute(:quantity, q.quantity-item.quantity)
    end

  end

  def fill_fake_attribute
    self.store_code = "fake"
    self.store_name = "fake"
  end

  def pay_by_paypal_or_allpay_or_delivery
    (payment == "PayPal" || payment == "AllPay" || payment == "貨到付款") ? true : false 
  end

  def ship_store_display
    (shipping_store.blank? || shipping_store == ",") ? "N/A" : shipping_store
  end

  def sum_item_price
    sum = 0
    order_items.each do |item|
      sum += (item.price * item.quantity)
    end
    sum
  end

  def apply_discount code
    coupon = DiscountRule.find_by(code: code)
    record = DiscountRecord.create(order_id: id, discount_rule_id: coupon.id)

    discount_products_ids = coupon.discount_products.map{|p| p.product_id}
    suitable_products = []
    discount_sum = 0
    sum = 0
    order_items.each do |item|
      sum += (item.price * item.quantity)
      if discount_products_ids.include? item.product_id
        suitable_products << item.product_id
        discount_sum += (item.price * item.quantity)
      end
    end

    if coupon.discount_type == DiscountRule::DISCOUNT_TYPE[2]
      self.total = sum
    elsif coupon.discount_type == DiscountRule::DISCOUNT_TYPE[0]
      dif = sum - discount_sum
      discount_sum = discount_sum - coupon.discount_money
      discount_sum = 0 if discount_sum < 0
      self.total = dif + discount_sum
    elsif coupon.discount_type == DiscountRule::DISCOUNT_TYPE[1]
      dif = sum - discount_sum
      discount_sum = (discount_sum * (100 - coupon.discount_percentage) / 100).round
      self.total = dif + discount_sum + shipping_cost.cost
    end
    self.save
  end

end
