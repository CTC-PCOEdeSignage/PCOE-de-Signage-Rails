class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.datetime :start_at, null: false
      t.integer :duration, null: false
      t.string :aasm_state, null: false
      t.text :purpose

      t.datetime :verified_at
      t.datetime :approved_at
      t.datetime :declined_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
