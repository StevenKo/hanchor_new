class CreateProductCategoryShips < ActiveRecord::Migration[5.1]
  def change
    create_table :product_category_ships do |t|
      t.integer :product_id
      t.integer :product_category_id
    end
    add_index :product_category_ships, :product_id
    add_index :product_category_ships, :product_category_id
  end
end
