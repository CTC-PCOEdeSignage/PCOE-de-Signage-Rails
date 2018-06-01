class RoomScreen < ApplicationRecord
  belongs_to :screen
  belongs_to :room
  validates_presence_of :position

  acts_as_list
end
