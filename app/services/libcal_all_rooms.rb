class LibCalAllRooms
  def initialize(token)
    @token = token
    @rooms = Room.all
  end
end
