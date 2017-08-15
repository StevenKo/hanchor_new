class NewsController < ApplicationController
  
  add_breadcrumb "首頁", :root_path

  def index
    @tags_selector = NewsTag.all.map{ |tag| [tag.locale(params[:locale]),tag.id]}
    if params[:news_tag_id].present? && params[:news_tag_id] != "0"
      news_tag = NewsTag.find(params[:news_tag_id])
      @news = news_tag.news.locale(params[:locale]).select("news.id, title, release_date, pic").paginate(:page => params[:page], :per_page => 15).order("news.release_date DESC")
    else
      @news = News.locale(params[:locale]).select("id, title, release_date, pic").paginate(:page => params[:page], :per_page => 15).order("news.release_date DESC")
    end
    add_breadcrumb "部落格", news_index_path(news_tag_id: params[:news_tag_id])
  end

  def show
    @recent_news = News.locale(params[:locale]).select("news.id, title, release_date, pic").limit(5).order("release_date DESC")
    @news = News.find(params[:id])
    add_breadcrumb "部落格", news_index_path
    add_breadcrumb @news.title, news_path(@news)
  end

end
