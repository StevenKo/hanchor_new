class News < ActiveRecord::Base
  mount_uploader :pic, ImageUploader

  has_many :news_tags_relations
  has_many :tags, :through => :news_tags_relations
  default_scope {order('sort DESC')}
  
  scope :locale, lambda { |locale|
    if (["zh-TW","zh"].include? locale)
      where(is_tw: true)
    else
      where(is_en: true)
    end
  }

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  def should_generate_new_friendly_id?
    !has_friendly_id_slug? || title_changed?
  end

  def has_friendly_id_slug?
    slugs.where(slug: slug).exists?
  end

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end

end
