class EventRequestsController < ApplicationController
  before_action :set_form

  def new
  end

  def create
    if (event = CreateEventRequest.call(@form))
      redirect_to room_event_request_confirmation_path(event.room, event)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_form
    @form = EventRequestForm.from_params(params).with_context(fallback_room: room)
  end

  def room
    @room ||= Room.find(params[:room_id])
  end
end
