class AddVerificationIdentifierToEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :verification_identifier, :string, null: false
  end
end
