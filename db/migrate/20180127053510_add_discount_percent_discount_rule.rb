class AddDiscountPercentDiscountRule < ActiveRecord::Migration[5.1]
  def change
  	add_column :discount_rules, :discount_percentage, :integer
  end
end
