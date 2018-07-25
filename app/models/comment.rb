class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :product_id, presence: true
  validates :context, presence: true

  has_one :reply, foreign_key: 'comment_id', class_name: 'Comment'

  scope :normal, ->{ where(comment_id: nil) }

  def self.compute_rating(comments_arr)
    return 0 if comments_arr.blank?

    rating = comments_arr.inject{ |sum, el| sum + el }.to_f / comments_arr.size
    rating.round(1)
  end

  def self.reply_hash(comment_ids)
    reply_arr = Comment.where(comment_id: comment_ids).pluck(:comment_id, :context, :created_at)

    reply_arr.each_with_object({}) do |comment, h|
      h[comment[0]] = {
        context: comment[1],
        datetime: comment[2].strftime("%Y/%m/%d %H:%M")
      }
    end
  end
end
