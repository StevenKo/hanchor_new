class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :product_id, presence: true
  validates :context, presence: true
  validates :rating, presence: true
  validates :name, presence: true

end
