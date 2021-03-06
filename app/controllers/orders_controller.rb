# encoding: utf-8
class OrdersController < ApplicationController
  before_action :get_cart_items
  before_action :load_base_cateogries, :only => [:result,:pay_with_credit_card]
  
  def create
    
    redirect_to root_path and return unless current_shopping_cart
    
    @order = Order.new(order_params)
    save_orders_info
    unless get_good_from_store(@order)
      @order.store_code = 0
      @order.store_name = "Fake Store"
    end
    @order.user_id = current_user.id
    @cart_items.each do |cart_item|
      order_item = OrderItem.new(product_id: cart_item.product_id, quantity: cart_item.quantity, price: cart_item.price, product_size_id: cart_item.product_size_id, product_color_id: cart_item.product_color_id)
      @order.order_items << order_item
    end
    @order.total = @order.sum_item_price + ShippingCost.find(params[:order][:shipping_cost_id]).cost if params[:order][:shipping_cost_id].present?
    @order.memo = params[:memo]
    @order.status = "order_confirm"
    @order.shipping_store = "#{params[:order][:store_code]},#{params[:order][:store_name]}" if(params[:order][:store_code] && params[:order][:store_name])
    if @order.dose_not_have_product_in_stock

      flash[:error] = @order.quantity_error_mesage(@country_id)
      redirect_back fallback_location: root_path
    else

      if @order.save
        @order.apply_discount(params[:code]) if params[:code].present?
        @order.update_attribute(:code, generate_order_code(@order))
        @order.deduct_quanitity

        if @order.total == 0
          UserMailer.order_notification(current_user,@order).deliver
          @order.update_attribute("is_show",true)
          redirect_to result_orders_url(order: @order) and return
        end

        if(@order.payment == "AllPay")
          redirect_to pay_with_credit_card_orders_path(order: @order)
        elsif(@order.payment == "PayPal")
          return_url = result_orders_url(order: @order)
          redirect_to current_shopping_cart.paypal_url(return_url,params[:locale],payment_notifications_url,@order.id,ShippingCost.find(params[:order][:shipping_cost_id]))
        else
          UserMailer.order_notification(current_user,@order).deliver
          @order.update_attribute("is_show",true)
          redirect_to result_orders_url(order: @order)
        end
      else
  
        redirect_to checkout_cart_index_path
      end
    end

    # return_url = result_orders_url
    # redirect_to current_shopping_cart.paypal_url(return_url)
  end

  def pay_with_credit_card
    @order = Order.find(params[:order])
    @discount_record = DiscountRecord.find_by(order_id: @order.id)
    product_ids = @order.order_items.map(&:product_id)
    products = Product.includes(:thumb).joins(:product_infos).where("product_infos.country_id = #{@country_id} and products.id in (#{product_ids.join(",")})").cart_info
    product_infos = {}
    products.each {|product| product_infos[product.id] = product}
    @order_products = []
    product_ids.each { |id| @order_products << product_infos[id] }
    # client = Allpay::Client.new(mode: :test)
    production_client = Allpay::Client.new({
      merchant_id: ENV['ALLPAY_ID'],
      hash_key: ENV['ALLPAY_HASH_KEY'],
      hash_iv: ENV['ALLPAY_HASH_IV']
    })
    @params = production_client.generate_checkout_params(MerchantTradeNo: @order.code,
                                            TotalAmount: @order.total,
                                            TradeDesc: "HANCHOR CO., LTD",
                                            ItemName: @order_products.map(&:name).join(","),
                                            ReturnURL: allpay_payment_notifications_url,
                                            ClientBackURL: result_orders_url(order: @order),
                                            ChoosePayment: 'Credit')
  end

  def result
    current_shopping_cart.delete if current_shopping_cart
    session[:cart_id] = nil
    @order = Order.find_by(id: params[:order], user_id: current_user.id)

    redirect_to root_path if @order.nil?
    add_breadcrumb "首頁", :root_path
    add_breadcrumb "訂購完成", result_orders_path(order:params[:order])
  end

  private

  def save_orders_info
    current_user.name = params[:order][:shipping_name] if current_user.name.nil?
    current_user.shipping_address = params[:order][:shipping_address] if current_user.shipping_address.nil?
    current_user.phone = params[:order][:phone] if current_user.phone.nil?
    current_user.zip_code = params[:order][:zip_code] if current_user.zip_code.nil?
    current_user.city = params[:order][:city] if current_user.city.nil?
    current_user.state = params[:order][:state] if current_user.state.nil?
    current_user.country = params[:order][:country] if current_user.country.nil?
    current_user.save
  end

  def generate_order_code order
    (order.created_at.strftime("%y%m%d")+ (Order.where("created_at > ?", order.created_at.to_date.in_time_zone("Taipei")).size).to_s.rjust(3, '0')).to_i + 100
  end

  def get_good_from_store(order)
    order.shipping_cost_id == 3
  end

  def order_params
    params.require(:order).permit(:shipping_name, :phone, :zip_code, :country, :city, :state, :shipping_address, :shipping_cost_id, :payment, :store_code, :store_name)
  end

end
