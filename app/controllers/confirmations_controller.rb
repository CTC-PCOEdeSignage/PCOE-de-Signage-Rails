class ConfirmationsController < ApplicationController
  before_action :room, only: [:show]
  before_action :event, only: [:show]

  def show
  end

  def verify
    verification_identifier = params.require(:verification_identifier)

    raise "Invalid Verification Identifier" unless room && event && event.verification_identifier == verification_identifier

    event.verify

    redirect_to room_event_request_confirmation_path(room, event)
  end

  private

  def room
    @room ||= Room.find_by(id: params[:room_id])
  end

  def event
    @event ||= room.events.find_by(id: params[:event_request_id])
  end
end
