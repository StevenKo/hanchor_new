class Admin::OrdersController < Admin::AdminController

  def index
    @orders = Order.showed.paginate(:page => params[:page], :per_page => 30).order("id DESC")
  end

  def show
    @order = Order.find(params[:id])
  end

  def change_status
    @order = Order.find(params[:id])
    @order.status = params[:value]
    @order.fill_fake_attribute
    if @order.save
      flash[:notice] = "successful change status"
    else
      flass[:error] = "error happen, try again"
    end
    redirect_to admin_order_path(@order)
  end

  def destroy
    order = Order.find(params[:id])
    order.update_attribute(:is_show, false)

    flash[:notice] = "delete success"
    redirect_to admin_orders_path
  end

  def export_orders
    attributes = %w{出貨編號 訂單日期 名字 聯絡電話 運送方式 國家 洲 城市 郵遞區號 收件地址 收款方式 付費資訊 總金額 意見 狀態 品名 尺寸 顏色 單價 數量 金額}
    @orders = Order.showed.limit(500).order("id DESC")
    file = CSV.generate(headers: true) do |csv|
      csv << attributes

      @orders.each do |order|
        order.order_items.each_with_index do |order_item,index|
          code = order.code + (index+1).to_s.rjust(2, '0')
          date = (order.created_at).strftime("%Y-%m-%d")
          ship_name = order.shipping_name
          phone = order.phone
          if order.shipping_cost.id == 3
            ship = order.shipping_cost.description + order.shipping_store
          else
            ship = order.shipping_cost.description
          end
          country = order.country
          state = order.state
          city = order.city
          zip_code = order.zip_code
          shipping_address = order.shipping_address
          payment = order.payment
          if order.bank
            bank_info = order.bank.gsub("\n","")
          else
            bank_info = ""
          end
          total = order.total
          memo = order.memo
          status = t("order.#{order.status}")
          if order_item.product.present?
            item_name = order_item.product.product_infos.first.name
          else
            item_name = "已刪除"
          end
          if order_item.product_size
            item_size = order_item.product_size.size
          else
            item_size = ""
          end
          if order_item.product_color
            item_color = order_item.product_color.color
          else
            item_color = ""
          end
          item_price = order_item.price
          item_quantity = order_item.quantity
          item_total = order_item.price * order_item.quantity
          csv << [code,date,ship_name,phone,ship,country,state,city,zip_code,shipping_address,payment,bank_info,total,memo,status,item_name,item_size,item_color,item_price,item_quantity,item_total]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data file, filename: 'Orders.csv' }
    end

    # @orders = Order.showed.all
    # respond_to do |format|
    #   format.xls
    # end
  end

end
