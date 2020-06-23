ActiveAdmin.register Event do
  menu priority: 2

  permit_params :user_id, :room_id, :start_at, :duration, :purpose

  member_action :run, method: :post do
    event_to_run = params[:aasm_event]
    resource.aasm.fire!(event_to_run)

    redirect_to admin_events_path, notice: "Event: #{resource.aasm.to_state.to_s.titleize}"
  end

  index do
    selectable_column
    column :user
    column :room
    column :start_at
    column "State" do |event|
      css_class = case
        when event.verified?
          "yes"
        when event.finished?
          "no"
        end
      status_tag event.aasm_state, class: css_class
    end

    actions do |event|
      event.aasm.events.each do |aasm_event|
        item aasm_event.name.to_s.titlecase, run_admin_event_path(event, aasm_event: aasm_event.name), class: "member_link", method: :post
      end

      nil
    end
  end

  filter :user
  filter :room
  filter :start_at

  scope :all, default: true
  scope :future
  scope :requested
  scope :verified
  scope :approved
  scope :declined
  scope :finished
  scope :needs_approval
end
