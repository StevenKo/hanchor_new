class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
    	t.string :email
    	t.boolean "is_registered", default: false
    end
  end
end
