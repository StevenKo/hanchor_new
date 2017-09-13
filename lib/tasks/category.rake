# encoding: utf-8
namespace :category do
  task :product_set_category => :environment do
    Product.all.each do |p|
      p.product_categories << ProductCategory.where(id: p.product_category_id)
    end
  end
end