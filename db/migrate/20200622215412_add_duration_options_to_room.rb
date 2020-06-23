class AddDurationOptionsToRoom < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :duration_options, :string
  end
end
