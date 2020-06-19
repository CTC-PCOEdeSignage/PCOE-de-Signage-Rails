class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def policies
    @policy_md = Settings.web.room_policies
  end
end
