class PlaylistSlide < ApplicationRecord
  belongs_to :playlist
  belongs_to :slide
  validates_presence_of :position

  acts_as_list

  after_initialize do
    self.length ||= ENV.fetch("DEFAULT_SLIDE_LENGTH", 30)
  end

end
