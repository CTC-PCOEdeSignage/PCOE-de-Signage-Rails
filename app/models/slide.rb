class Slide < ApplicationRecord
  has_many :playlist_slides
  has_many :playlists, through: :playlist_slides

  has_one_attached :image

  def self.styles
    %w(libcal-all-schedule-slide image markup)
    # TODO: Add dynamic styles
  end

  def self.default_slide
    @@default_slide ||= Slide.new(name: "Default Slide", style: "markup", markup: "<h1>Slide Not Found</h1>")
  end
end
