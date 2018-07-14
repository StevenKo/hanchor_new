class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :product_id, presence: true
  validates :context, presence: true
  validates :rating, presence: true
  validates :name, presence: true


  def self.compute_rating(comments_arr)
    return 0 if comments_arr.blank?

    rating = comments_arr.inject{ |sum, el| sum + el }.to_f / comments_arr.size
    rating.round(1)
  end
end
