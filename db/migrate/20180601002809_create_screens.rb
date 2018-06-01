class CreateScreens < ActiveRecord::Migration[5.2]
  def change
    create_table :screens do |t|
      t.string :name, null: false
      t.integer :rotation, null: false
      t.string :layout, null: false
      t.integer :playlist_id

      t.timestamps
    end
  end
end
