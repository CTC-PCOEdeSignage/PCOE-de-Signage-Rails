ActiveAdmin.register User do
  menu priority: 1

  permit_params :email, :first_name, :last_name

  member_action :run, method: :post do
    event_to_run = params[:aasm_event]
    resource.aasm.fire!(event_to_run)

    redirect_to resource_path, notice: event_to_run
  end

  index do
    selectable_column
    id_column
    column :name
    column :email
    column "State" do |user|
      css_class = case
        when user.whitelisted?
          "yes"
        when user.blacklisted?
          "no"
        end
      status_tag user.aasm_state, class: css_class
    end

    actions do |user|
      user.aasm.events.each do |aasm_event|
        item aasm_event.name.to_s.titlecase, run_admin_user_path(user, aasm_event: aasm_event.name), class: "member_link", method: :post
      end

      nil
    end
  end

  filter :first_name
  filter :last_name
  filter :email

  scope :all, default: true
  scope :quarantined
  scope :whitelisted
  scope :blacklisted

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
    end
    f.actions
  end
end
