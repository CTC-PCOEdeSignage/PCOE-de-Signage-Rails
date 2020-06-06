class EventRequestsController < ApplicationController
  before_action :set_form

  def new
  end

  def create
    CreateEventRequest.call(@form) do
      on(:ok) { |event| redirect_to room_event_request_confirmation_path(event.room, event) }
      on(:invalid) { render :new }
    end
  end

  private

  def set_form
    @form = EventRequestForm.from_params(params).with_context(room: room)
  end

  def room
    @room ||= Room.find(params[:room_id])
  end
end
