class RemoveRoomLibcalIdentifier < ActiveRecord::Migration[6.0]
  def change
    remove_column :rooms, :libcal_identifier
  end
end
