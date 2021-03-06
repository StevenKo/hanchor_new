class WelcomeController < ApplicationController
  before_action :load_base_cateogries
  
  add_breadcrumb I18n.t("product.home"), :root_path

  def index
    @news = News.locale(params[:locale]).select("news.id, title, release_date, pic, slug").limit(6).order("news.release_date DESC")
    @video = Video.first
    @products = Product.includes(:thumb).joins(:product_infos).where("product_infos.country_id = #{@country_id} and is_show_at_index = true").showed.order_by_views_and_sort.select_info
    @banners = Banner.showed.order("sort DESC")
  end

  def faq
    @faq = Faq.find_by(country_id: @country_id, purpose: "faq")
    redirect_to :shopping_guide if @country_id == 2
    add_breadcrumb t('faq.faq'), faq_path
  end

  def shopping_guide
    @guide = Faq.find_by(country_id: @country_id, purpose: "shopping_guide")
    add_breadcrumb t('faq.guide'), shopping_guide_path
  end

  def aboutus
    add_breadcrumb t('aboutus'), aboutus_path
  end

  def subscribe

    subscription = Subscription.find_or_initialize_by(email: params[:email])
    subscription.is_registered = true if User.where(email: params[:email]).exists?
    (subscription.new_record?)? @old = false : @old = true 
    if subscription.save
      @success = true
    else
      @success = false
    end
  end
end
