class AddDurationOptionsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :duration_options, :string
  end
end
