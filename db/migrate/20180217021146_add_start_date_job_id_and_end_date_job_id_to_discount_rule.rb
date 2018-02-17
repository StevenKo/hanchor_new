class AddStartDateJobIdAndEndDateJobIdToDiscountRule < ActiveRecord::Migration[5.1]
  def change
  	add_column :discount_rules, :start_date_job_id, :string
  	add_column :discount_rules, :end_date_job_id, :string
  end
end
