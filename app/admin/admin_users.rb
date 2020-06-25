ActiveAdmin.register AdminUser do
  menu priority: 99

  permit_params :email, :receive_event_approvals, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :receive_event_approvals
    column :created_at
    actions
  end

  scope :all
  scope :receive_event_approvals

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :receive_event_approvals
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
