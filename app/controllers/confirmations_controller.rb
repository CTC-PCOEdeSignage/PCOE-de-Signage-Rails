class ConfirmationsController < ApplicationController
  before_action do
    @room = Room.find(params[:room_id])
    @event = @room.events.find(params[:event_request_id])
  end

  def show
  end

  def update
  end
end
