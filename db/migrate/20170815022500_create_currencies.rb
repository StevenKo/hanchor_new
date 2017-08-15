class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string :symbol
      t.float :cash_buy
      t.float :cash_sell
      t.float :buy
      t.float :sell
    end
    add_index :currencies, :symbol
  end
end
