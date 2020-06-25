class AddReceiveEventApprovalsToAdminUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :receive_event_approvals, :boolean, null: false, default: false
  end
end
