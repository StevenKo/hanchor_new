class CreateAnnouncements < ActiveRecord::Migration[5.1]
  def change
    create_table :announcements do |t|
      t.text :message
      t.string :link
      t.integer :sort
      t.timestamps
    end
  end
end
