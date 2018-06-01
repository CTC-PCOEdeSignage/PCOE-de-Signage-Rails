class CreateRoomScreens < ActiveRecord::Migration[5.2]
  def change
    create_table :room_screens do |t|
      t.integer :screen_id, null: false
      t.integer :room_id, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
