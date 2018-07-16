class CommentsController < ApplicationController
  def create
    comment = Comment.new(
      name: params[:name] || current_user.name,
      rating: params[:rating].to_i,
      context: params[:context],
      product_id: params[:product_id].to_i,
    )
    comment.user = current_user if current_user

    return ok(comment.to_json) if comment.save
    head(404)
  end
end
