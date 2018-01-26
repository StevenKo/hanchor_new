class CreateDiscountRules < ActiveRecord::Migration[5.1]
  def change
    create_table :discount_rules do |t|
      t.text :title
      t.string :discount_type
      t.integer :discount_money
      t.integer :threshold
      t.datetime :end_date
      t.datetime :start_date
      t.boolean :is_valid, default: true
      t.string :code

      t.timestamps
    end
    add_index :discount_rules, :code

    create_table :discount_products do |t|
      t.integer :discount_rule_id, index: true
      t.references :product, index: true
    end


    create_table :discount_records do |t|
      t.integer :discount_rule_id, index: true
      t.references :order, index: true
      t.datetime :created_at
    end

  end
end
