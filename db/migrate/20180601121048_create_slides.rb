class CreateSlides < ActiveRecord::Migration[5.2]
  def change
    create_table :slides do |t|
      t.string :name, null: false
      t.string :style, null: false
      t.text :markup

      t.timestamps
    end
  end
end
