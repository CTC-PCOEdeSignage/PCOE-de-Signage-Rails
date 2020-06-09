ActiveAdmin.register User do
  menu priority: 1

  permit_params :email, :first_name, :last_name

  member_action :run, method: :post do
    event_to_run = params[:aasm_event]
    resource.aasm.fire!(event_to_run)

    redirect_to resource_path, notice: event_to_run
  end

  action_item only: :index do
    link_to "Import Users", action: :import_users
  end

  collection_action :import_users, method: :get do
    render "admin/import/users"
  end

  collection_action :import_users_csv, method: :post do
    csv_file = params[:users][:file].read
    default_state = case params[:users][:options]
      when "decline_all"
        "declined"
      when "quarantine_all"
        "quarantined"
      else
        "approved"
      end
    user_count = 0

    CSV.parse(csv_file, headers: true) do |row|
      row = row.to_h.transform_keys { |key| key.strip.downcase.gsub(/\s/, "_") }
      obj = User.find_or_initialize_by(email: row["email"])

      row = row.slice("email", "first_name", "last_name", "status")
      row["aasm_state"] = row.delete("status") || default_state

      obj.update(row)
      user_count += 1
    rescue => e
      flash[:alert] = "Import error: #{e.message}"
      redirect_to action: :index
      return
    end

    flash[:notice] = "Successfully imported #{user_count} users."
    redirect_to action: :index
  end

  index do
    selectable_column
    id_column
    column :name
    column :email
    column "State" do |user|
      css_class = case
        when user.approved?
          "yes"
        when user.declined?
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
  scope :approved
  scope :declined

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
    end
    f.actions
  end
end
