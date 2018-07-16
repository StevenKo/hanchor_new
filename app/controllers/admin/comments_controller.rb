class Admin::CommentsController < Admin::AdminController
  def index
    @comments = Comment.order(id: :desc).includes([product: :product_infos])

    if params[:search]
      @comments = @comments.where('product_infos.name like ?', "%#{params[:search]}%")
                           .references(:product_infos)
    end

    @comments = @comments.paginate(page: params[:page], per_page: 20)
  end
end
