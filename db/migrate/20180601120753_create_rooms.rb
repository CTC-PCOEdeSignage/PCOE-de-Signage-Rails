class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :building, null: false
      t.string :room, null: false
      t.string :name, null: false
      t.integer :libcal_identifier, null: false

      t.timestamps
    end
  end
end
