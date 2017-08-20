class Admin::ProductPicsController < Admin::AdminController
  skip_before_action :verify_authenticity_token, only: [:sort]
  def index
    @product = Product.find_by_slug(params[:product_id])
    @pics = @product.product_pics
    @new_pic = ProductPic.new
  end

  def create
    @pic = ProductPic.new(params.require(:product_pic).permit(:product_id,:pic))
    @product = Product.find_by_slug(params[:product_id])
    @pic.sort =  @product.product_pics.size + 1
    @pic.save
  end

  def edit
    @pic = ProductPic.find(params[:id])
    @product = Product.find_by_slug(params[:product_id])
  end

  def update
    @pic = ProductPic.find(params[:id])
    if @pic.update_attributes(params.require(:product_pic).permit(:description,:pic))
      flash[:notice] = "Updated"
      redirect_to admin_product_product_pics_path
    else
      flash[:error] = "something wrong"
      render :edit
    end
  end

  def destroy
    @pic = ProductPic.find(params[:id])
    @pic.delete
    flash[:notice] = "Pic successfully destroyed."
    Product.find_by_slug(params[:product_id]).reorder_pic_sort
    redirect_to admin_product_product_pics_path
  end

  def sort
    params[:product_pic].each_with_index do |id, index|
      ProductPic.where(id: id).update_all(sort: index+1)
    end
    render body: nil
  end

end
