class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create,:allpay]
  
  def create
    Rails.logger.info("PARAMS: #{params.inspect}")
    if (params[:payment_status] == "Completed")
      order = Order.find(params[:invoice])
      if order.is_payed == false
        order.status = "pay_confirm"
        order.is_show = true
        order.is_payed = true
        order.fill_fake_attribute
        order.save
        UserMailer.order_notification(order.user,order).deliver
      end
    elsif(params[:payment_status] == "Canceled_Reversal" || params[:payment_status] == "Denied")
      order = Order.find(params[:invoice])
      order.is_show = false
      order.save
    end
    response = validate_IPN_notification(request.raw_post)
    render :nothing => true
  end

  def allpay
    Rails.logger.info("PARAMS: #{params.inspect}")
    if (params[:RtnCode] == "1")
      order = Order.find_by(code: params[:MerchantTradeNo])
      if order.is_payed == false
        order.status = "pay_confirm"
        order.is_show = true
        order.is_payed = true
        order.fill_fake_attribute
        order.save
        UserMailer.order_notification(order.user,order).deliver
      end
      render :text => "1|OK"
    elsif(params[:RtnCode] != "1")
      order = Order.find_by(code: params[:MerchantTradeNo])
      order.is_show = false
      order.save
      render :text => "0|Error"
    end
  end

  protected 
  def validate_IPN_notification(raw)
    uri = URI.parse('https://www.paypal.com/cgi-bin/webscr?cmd=_notify-validate')
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.use_ssl = true
    response = http.post(uri.request_uri, raw,
                         'Content-Length' => "#{raw.size}",
                         'User-Agent' => "My custom user agent"
                       ).body

    Rails.logger.info("paypal validate response: #{response}")
  end
end
