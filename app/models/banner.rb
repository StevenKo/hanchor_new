class Banner < ActiveRecord::Base
  mount_uploader :pic, ImageUploader

  PRODUCT_BANNER_ID = 1
  BLOG_BANNER_ID = 2
  FAQ_BANNER_ID = 3

end
