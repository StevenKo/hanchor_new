class AddEmailToComment < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :email, :string, after: :name
  end
end
