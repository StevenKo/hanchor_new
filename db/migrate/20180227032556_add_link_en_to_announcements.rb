class AddLinkEnToAnnouncements < ActiveRecord::Migration[5.1]
  def change
  	add_column :announcements, :link_en, :string
  end
end
