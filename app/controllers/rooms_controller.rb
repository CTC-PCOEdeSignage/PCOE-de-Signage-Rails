class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def policies
    @policy_paragraphs = SystemConfiguration.get("web", "room_policies").split("\n")
  end
end
