# frozen_string_literal: true

class Slide < ApplicationRecord
  has_many :playlist_slides
  has_many :playlists, through: :playlist_slides

  has_one_attached :image

  validates_uniqueness_of :name

  def self.styles
    Dir[styles_path.join("**", "*#{styles_ext}")].map do |f|
      # Remove the start of the path (including the _) and remove extension
      # /path/to/app/views/slides/_libcal-all-schedule-slide.html.erb =>
      # _libcal-all-schedule-slide.html.erb
      File.basename(f)
    end
      .concat(["image", "markup"])
  end

  def self.styles_path
    Rails.root.join("app", "views", "slides")
  end

  def self.styles_ext
    ".html.erb"
  end

  def self.default_slide
    @@default_slide ||= Slide.new(name: "Default Slide", style: "markup", markup: "<h1>Slide Not Found</h1>")
  end
end
