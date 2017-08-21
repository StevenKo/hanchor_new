class AddIsVisibleToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :is_visible, :boolean, default: true
    Product.all.each do |p|
      infos = p.product_infos
      unless infos.map{|i| i.is_visible}.any?
        p.is_visible = false
        p.save
      end
    end
  end
end
