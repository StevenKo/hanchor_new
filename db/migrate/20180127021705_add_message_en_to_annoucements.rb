class AddMessageEnToAnnoucements < ActiveRecord::Migration[5.1]
  def change
  	add_column :announcements, :message_en, :text
  end
end
