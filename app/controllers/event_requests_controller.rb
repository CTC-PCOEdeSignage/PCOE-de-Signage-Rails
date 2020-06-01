class EventRequestsController < ApplicationController
  before_action do
    room = Room.find(params[:room_id])
    @form = EventRequestForm.from_params(params).with_context(room: room)
  end

  def new
  end

  def create
    CreateEventRequest.call(@form) do
      on(:ok) { |event| redirect_to room_event_request_confirmation_path(event.room, event) }
      on(:invalid) { render :new }
    end
  end
end
