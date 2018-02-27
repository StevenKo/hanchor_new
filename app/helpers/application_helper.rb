module ApplicationHelper
  def display_date date
    date.strftime("%Y-%m-%d")
  end

  def link_to_currency currency
    if session[:currency_id].to_i == currency.id
      link_to currency.symbol, set_currency_path(currency_id: currency.id), class: "active"
    else
      link_to currency.symbol, set_currency_path(currency_id: currency.id)
    end
  end

  def link_to_language codes, link_text
    if codes.include? session[:locale]
      link_to link_text, url_for(params.merge(:only_path => true, locale: codes[0])), class: "active"
    else
      link_to link_text, url_for(params.merge(:only_path => true, locale: codes[0]))
    end
  end

  def showed_announcement announcement
    if ["zh-TW","zh"].include?( params[:locale] )
      announcement.message
    else
      announcement.message_en
    end
  end

  def link_to_announceemnt announcement
    if ["zh-TW","zh"].include?( params[:locale] )
      link_to announcement.message, announcement.link, {class: "h-msg-l", :voh => "0.4"}
    else
      link_to announcement.message_en, announcement.link_en, {class: "h-msg-l", :voh => "0.4"}
    end
  end
end
