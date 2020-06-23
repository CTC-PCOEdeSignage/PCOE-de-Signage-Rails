class AddLimitFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :events_in_future, :integer
    add_column :users, :days_in_future, :integer
  end
end
