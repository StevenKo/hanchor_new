class AddPicAndRgbToProductColor < ActiveRecord::Migration[5.1]
  def change
  	add_column :product_colors, :rgb, :string, :default => "#1c1c1b"
  	add_column :product_colors, :pic, :string
  end
end
