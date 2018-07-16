class Admin::CommentsController < Admin::AdminController
  def index
    @comments = Comment.order(id: :desc).includes([product: :product_infos])

    if params[:search]
      @comments = @comments.where('product_infos.name like ?', "%#{params[:search]}%")
                           .references(:product_infos)
    end

    @comments = @comments.paginate(page: params[:page], per_page: 20)
  end

  def destroy
    comment = Comment.find_by(id: params[:id])
    comment.destroy!
    redirect_to admin_comments_path, :notice => "The Comment has been deleted!"
  end
end
