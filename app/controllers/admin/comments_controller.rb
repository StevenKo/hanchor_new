class Admin::CommentsController < Admin::AdminController
  def index
    @comments = Comment.order(id: :desc)
                       .includes([product: :product_infos])
                       .paginate(page: params[:page], per_page: 20)
  end
end



