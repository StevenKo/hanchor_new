class Admin::CommentsController < Admin::AdminController
  before_action :set_reply, only: [:show, :edit, :update, :delete_reply]

  def index
    @comments = Comment.order(id: :desc).where(comment_id: nil).includes([product: :product_infos])

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

  #----------------------------------
  # Below methods are for Replying
  #----------------------------------

  def show
  end

  def new
    @reply = Comment.new
  end

  def edit
  end

  def create
    reply = Comment.new(reply_params)
    reply.user = current_admin

    respond_to do |format|
      if reply.save
        format.html { redirect_to [:admin, reply], notice: 'Reply was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @reply.update(reply_params)
        format.html { redirect_to [:admin, @reply], notice: 'Reply was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def delete_reply
    reply = Comment.find_by(id: params[:format])
    redirect_to admin_comments_path, :notice => "The Reply has been deleted!" if reply.destroy
  end

  #----------------------------------
  # Above methods are for Replying
  #----------------------------------

  private

  def set_reply
    @reply = Comment.find_by(id: params[:id])
  end

  def reply_params
    params.require(:comment).permit(:context, :comment_id, :product_id)
  end


end

