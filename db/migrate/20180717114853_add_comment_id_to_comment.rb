class AddCommentIdToComment < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :comment_id, :integer, after: :product_id
    add_index :comments, :comment_id
  end
end
