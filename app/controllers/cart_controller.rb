# encoding: utf-8
class CartController < ApplicationController
  before_action :require_user, only: [:checkout]
  before_action :get_cart_items, only: [:index,:checkout]
  before_action :load_base_cateogries
  add_breadcrumb I18n.t("product.home"), :root_path

  def index
    add_breadcrumb t("shopping_cart"), cart_index_path
    if params[:code].present?
      @coupon = DiscountRule.find_by(code: params[:code])
      @is_useable = current_shopping_cart.calculate_coupon(@coupon.id)
      if @is_useable.is_valid
        @coupon_message = I18n.t("cart.applied_code")
      elsif @is_useable.is_less_than_threshold
        @coupon_message = I18n.t("cart.code_threshold",threshold: @coupon.threshold)
      else
        @coupon_message = I18n.t("cart.not_suitable_code")
      end
    end
  end

  def add_item_to_cart
    product = Product.find_by_slug(params[:product])
    item = CartItem.new(params.require(:cart_item).permit(:product_color_id,:product_size_id))
    item.quantity = params[:quantity]
    item.product = product
    info = product.product_infos.where("country_id = #{@country_id}").select("special_price,price")[0]
    (info.special_price.present?) ?  item.price = info.special_price : item.price = info.price
    if current_shopping_cart
      if current_shopping_cart.cart_items.select("product_id").map{|c| c.product_id}.include?(product.id)
        item = set_item_by_check_item_color_size(current_shopping_cart,product,item)
      else
        item.cart = current_shopping_cart
      end 
    else
      cart = Cart.create(user_id: session[:user_id])
      session[:cart_id] = cart.id
      item.cart = cart
    end
    item.save
    
    redirect_to products_show_path(product.product_categories[0].name_en,product)
  end

  def set_item_by_check_item_color_size(current_shopping_cart,product,item)
    cart_item = current_shopping_cart.cart_items.find_by(product_id: product.id, product_color_id: params["cart_item"]["product_color_id"], product_size_id: params["cart_item"]["product_size_id"])
    if cart_item
      item = cart_item
      item.quantity = params[:quantity]
    else
      item.cart = current_shopping_cart
    end
    item
  end

  def remove_cart_item
    CartItem.delete(params[:item_id])
    redirect_back fallback_location: root_path
  end

  def change_cart_item_quantity
    item = CartItem.find(params[:id])
    item.quantity = params[:cart_item][:quantity]
    unless item.save
      flash[:error] = "錯誤發生，麻煩你再重試一次，或聯絡我們！"
    end
    redirect_to cart_index_path
  end

  def checkout
    add_breadcrumb t("shopping_cart_locale.checkout_breadcrumb"), checkout_cart_index_path
    if (@cart_items.present?)
      @order = Order.new
      shipping_array = YAML::load(@cart_products[0].shipping)
      @cart_products.each do |p|
        shipping_array = shipping_array & YAML::load(p.shipping)
      end
      @shippings = ShippingCost.where(id: shipping_array)
      @shippings_selector = @shippings.map{ |s| ["#{s.description}($NT#{s.cost})",s.id]}
      if params[:code].present?
        @coupon = DiscountRule.find_by(code: params[:code])
        @is_useable = current_shopping_cart.calculate_coupon(@coupon.id)
      end
    else
      flash[:error] = "There is nothing in shopping cart!"
      redirect_to root_path
    end
  end

  def check_out_shipping
    if params[:code].present?
      @coupon = DiscountRule.find_by(code: params[:code])
      @is_useable = current_shopping_cart.calculate_coupon(@coupon.id)
    end
    @shipping = ShippingCost.find(params[:shipping_cost_id])
  end
end
