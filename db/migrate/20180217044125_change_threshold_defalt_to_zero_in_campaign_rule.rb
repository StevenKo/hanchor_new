class ChangeThresholdDefaltToZeroInCampaignRule < ActiveRecord::Migration[5.1]
  def change
  	change_column :discount_rules, :threshold, :integer, default: 0
  end
end
