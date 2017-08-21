class CreateRecommendShips < ActiveRecord::Migration[5.1]
  def change
    create_table :recommend_ships do |t|
      t.integer :product_id
      t.integer :recommend_id
      t.integer :sort, default: 0
    end
    add_index :recommend_ships, :product_id
    add_index :recommend_ships, :recommend_id
    add_index :recommend_ships, :sort
  end
end
