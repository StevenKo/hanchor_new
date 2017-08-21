class ProductInfo < ActiveRecord::Base
  belongs_to :product
  belongs_to :country

  serialize :shipping, Array
  after_save :check_visible
  after_save :update_proudct_slug

  def check_visible
    product.update_visible if is_visible_changed?
  end

  def update_proudct_slug
    product.update_slug if name_changed?
  end
end
