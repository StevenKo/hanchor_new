class NewsController < ApplicationController
  before_action :load_base_cateogries
  
  add_breadcrumb "首頁", :root_path

  def index
    @tags_selector = NewsTag.all.map{ |tag| [tag.locale(params[:locale]),tag.id]}
    if params[:news_tag_id].present? && params[:news_tag_id] != "0"
      @news_tag = NewsTag.find(params[:news_tag_id])
      @news = @news_tag.news.locale(params[:locale]).select("news.id, title, release_date, pic, slug").paginate(:page => params[:page], :per_page => 15).order("news.release_date DESC")
    else
      @news = News.locale(params[:locale]).select("id, title, release_date, pic, slug").paginate(:page => params[:page], :per_page => 15).order("news.release_date DESC")
    end
    add_breadcrumb "部落格", news_index_path(news_tag_id: params[:news_tag_id])
  end

  def show
    @recent_news = News.locale(params[:locale]).select("news.id, title, release_date, pic, slug").limit(5).order("release_date DESC")
    @news = News.friendly.find(params[:id])
    add_breadcrumb "部落格", news_index_path
    add_breadcrumb @news.title, news_path(@news)
    respond_with_article_or_redirect
  end

  private

  def respond_with_article_or_redirect
    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    if request.path != news_path(@news).split("?")[0]
      return redirect_to @news, status: :moved_permanently
    end
  end
end
