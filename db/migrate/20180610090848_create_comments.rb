class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :context
      t.integer :rating
      t.string :name
      t.integer :user_id, index: true
      t.integer :product_id, index: true

      t.timestamps
    end
  end
end
