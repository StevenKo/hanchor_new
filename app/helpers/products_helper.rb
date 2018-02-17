module ProductsHelper
  def link_to_category path,text,type_num
    if request.fullpath.split("?")[0] == path.split("?")[0]
      link_to text, path, {:class => "type-#{type_num} active"}
    else
      link_to text, path, {:class => "type-#{type_num}"}
    end
  end

  def showed_price price
    if current_currency.symbol == "NTD"
      "#{current_currency.show_symbol}#{price}"
    else
      "#{current_currency.show_symbol}#{(price / current_currency.sell).round(2)}"
    end
  end

  def showed_color color
    if ["zh-TW","zh"].include?( params[:locale] )
      color.color
    else
      color.color_en
    end
  end
end
