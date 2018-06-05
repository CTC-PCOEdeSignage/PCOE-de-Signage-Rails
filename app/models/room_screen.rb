class RoomScreen < ApplicationRecord
  belongs_to :screen
  belongs_to :room
  validates_presence_of :position

  default_scope { order(position: :asc) }

  acts_as_list
end
