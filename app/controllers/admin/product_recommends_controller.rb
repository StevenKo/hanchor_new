class Admin::ProductRecommendsController < Admin::AdminController
  skip_before_action :verify_authenticity_token, only: [:sort]
  def index
    @product = Product.find_by_slug(params[:product_id])
    @recommends = @product.recommends.select("products.id, slug, recommend_ships.id as r_id").order("recommend_ships.sort asc")
    @all_products = Product.showed
  end

  def create
    @product = Product.find_by_slug(params[:product_id])
    @product.recommends.delete_all
    @product.recommends << Product.where(id: params[:products][:is_recommend])
    redirect_to admin_product_product_recommends_path(@product)
  end

  def sort
    params[:product_recommend].each_with_index do |id, index|
      RecommendShip.where(id: id).update_all(sort: index+1)
    end
    render body: nil
  end

end
