class AddLengthToPlaylistSlide < ActiveRecord::Migration[5.2]
  def change
    add_column :playlist_slides, :length, :integer
  end
end
