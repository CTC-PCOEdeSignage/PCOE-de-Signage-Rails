User::IMPORT_HEADER_ROWS ||=
  [
    "email",
    "first_name",
    "last_name",
    "status"
  ]

ActiveAdmin.register User do
  menu priority: 1

  permit_params :email, :first_name, :last_name, :duration_options_string, :events_in_future, :days_in_future

  member_action :run, method: :post do
    event_to_run = params[:aasm_event]
    resource.aasm.fire!(event_to_run)

    redirect_to admin_users_path, notice: "User: #{resource.aasm.to_state.to_s.titleize}"
  end

  action_item only: :index do
    link_to "Import Users", action: :import_users
  end
  action_item only: :index do
    link_to "Delete All Users", delete_all_users_admin_users_path, method: :delete, data: { confirm: "Are you sure?" }
  end

  collection_action :import_users, method: :get do
    render "admin/import/users"
  end

  collection_action :delete_all_users, method: :delete do
    User.includes(:events).find_each do |user|
      user.transaction do
        user.events.each(&:destroy!)
        user.destroy!
      end
    end

    redirect_to admin_users_path, alert: "All users deleted."
  end

  collection_action :import_users_csv, method: :post do
    if params[:users].nil? || params[:users][:file].nil?
      redirect_to import_users_admin_users_path, alert: "Import error: Import not valid. Please select a CSV file and default status option"
      return
    end

    csv_file = params[:users][:file].read
    default_status_option = params[:users][:default_status_option]
    default_status = default_status_option if ["declined", "quarantined", "approved"].include?(default_status_option)
    default_status ||= "approved"

    initial_user_count = User.count
    line_count = 0

    begin
      User.transaction do
        CSV.parse(csv_file, headers: true) do |row|
          row = row.to_h
          row = row.transform_keys { |key| key&.strip&.downcase&.gsub(/\s/, "_") }
          row = row.slice(*User::IMPORT_HEADER_ROWS)

          next unless row["email"].present?

          user = User.find_or_initialize_by(email: row["email"])

          row["aasm_state"] = (row.delete("status").presence || default_status).downcase

          user.assign_attributes(row)
          user.save!
          line_count += 1
        end
      end
    rescue => e
      redirect_to import_users_admin_users_path, alert: "Import error: #{e.message}"
      return
    end

    imported_user_count = User.count - initial_user_count

    redirect_to admin_users_path, notice: "Successfully imported #{imported_user_count} users (or updated #{line_count} users)."
  end

  collection_action :import_users_example_csv, method: :get do
    render plain: CSV.generate { |csv| csv << User::IMPORT_HEADER_ROWS },
           content_type: "text/csv"
  end

  index do
    selectable_column
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
      f.input :duration_options_string, label: "Duration Options"
      f.input :events_in_future, label: "Limit: Events in Future"
      f.input :days_in_future, label: "Limit: Days in Future"
    end
    f.actions
  end
end
