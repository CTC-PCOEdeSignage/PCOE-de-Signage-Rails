class RemoveDefaultValueFromAasmFields < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:users, :aasm_state, nil)
    change_column_default(:events, :aasm_state, nil)
  end
end
