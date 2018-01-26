class AddTitleEnToDiscountRule < ActiveRecord::Migration[5.1]
  def change
  	add_column :discount_rules, :title_en, :string
  end
end
