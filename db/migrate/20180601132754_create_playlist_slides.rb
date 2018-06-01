class CreatePlaylistSlides < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_slides do |t|
      t.integer :playlist_id, null: false
      t.integer :slide_id, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
