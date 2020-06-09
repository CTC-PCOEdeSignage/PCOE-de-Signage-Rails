# frozen_string_literal: true

class Slide < ApplicationRecord
  STYLES_PATH = Rails.root.join("app", "views", "slides")
  # Remove the start of path and extension
  # /path/to/app/views/slides/_partial-slide.html.erb => _partial-slide.html.erb
  STYLE_OPTIONS = Dir[STYLES_PATH.join("**/*.html.erb")].map { |f| File.basename(f) }.concat(["image", "markup"])

  has_many :playlist_slides
  has_many :playlists, through: :playlist_slides, dependent: :destroy

  has_one_attached :image

  validates_presence_of :name, :style
  validates_uniqueness_of :name
  validates_inclusion_of :style, in: STYLE_OPTIONS

  def self.default_slide
    @@default_slide ||= Slide.new(name: "Default Slide", style: "markup", markup: "<h1>Slide Not Found</h1>")
  end
end
