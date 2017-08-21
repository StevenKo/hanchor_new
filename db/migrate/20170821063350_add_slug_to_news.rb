class AddSlugToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :slug, :string
    add_index :news, :slug
  end
end
