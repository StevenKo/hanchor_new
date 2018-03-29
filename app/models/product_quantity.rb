class ProductQuantity < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_color, optional: true
  belongs_to :product_size, optional: true


  def self.create_quantiy product_id
    colors = ProductColor.where("product_id = #{product_id} and is_delete != true")
    sizes = ProductSize.where("product_id = #{product_id} and is_delete != true")
    colors.each do |color|
      sizes.each do |size|
        quantity = ProductQuantity.where("product_color_id = #{color.id} and product_size_id = #{size.id}").first
        ProductQuantity.create(product_id: product_id, product_color_id: color.id, product_size_id: size.id) if quantity.blank?
        ProductQuantity.where("product_id = #{product_id} and (product_color_id is null or product_size_id is null) ").delete_all
      end
    end

    if colors.blank?
      sizes.each do |size|
        quantity = ProductQuantity.where("product_size_id = #{size.id}").first
        ProductQuantity.create(product_id: product_id, product_size_id: size.id) if quantity.blank?
      end
    end

    if sizes.blank?
      colors.each do |color|
        quantity = ProductQuantity.where("product_color_id = #{color.id}").first
        ProductQuantity.create(product_id: product_id, product_color_id: color.id) if quantity.blank?
      end
    end

  end

  def self.delete_color_quantity product_color_id

    ProductQuantity.where("product_color_id = #{product_color_id}").delete_all
  end

  def self.delete_size_quantity product_size_id
    ProductQuantity.where("product_size_id = #{product_size_id}").delete_all
  end

  def quantity_selector
    (1..quantity).map{|i| [i,i]}
  end

end
