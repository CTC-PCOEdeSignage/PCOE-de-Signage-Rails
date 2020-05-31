class EventRequestsController < ApplicationController
  before_action do
    @room = Room.find(params[:room_id])
    @form = EventRequestForm.from_params(params)
  end

  def new
  end

  def create
    @form = EventRequestForm.from_params(params)

    if @form.valid?
      RequestEvent.call(@form) do
        on(:ok) { redirect_to dashboard_path }
        on(:invalid) { render :new }
        on(:already_registered) { redirect_to login_path }
      end
    end
  end
end
