ActiveAdmin.register_page "Bulk Schedule" do
  page_action :schedule, method: :post do
    permitted_params = params.permit(:recurring_rule, :event_purpose, :event_email, :start_time, :duration, :end_date, rooms: [])

    case
    when params["check"]
      availability = Rooms::BulkAvailability.new(params: permitted_params).availability
      render partial: "events", locals: { availability: availability }
    when params["set"]
      availability = Rooms::BulkAvailability.new(params: permitted_params).persist!
      render partial: "scheduled", locals: { availability: availability }
    else
      raise "Unknown Action"
    end
  end

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Schedule Many Rooms" do
          render partial: "form"
        end
      end
    end
  end
end
