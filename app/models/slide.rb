# frozen_string_literal: true

class Slide < ApplicationRecord
  has_many :playlist_slides
  has_many :playlists, through: :playlist_slides

  has_one_attached :image

  def self.styles
    ext = ".html.erb"
    style_root = Rails.root.join("app", "views", "slides", "**", "*#{ext}").to_s
    styles = Dir[style_root].map {|p| f = File.basename(p); f[1..f.length - (ext.length + 1)] }

    styles.push("image", "markup")
  end

  def self.default_slide
    @@default_slide ||= Slide.new(name: "Default Slide", style: "markup", markup: "<h1>Slide Not Found</h1>")
  end
end
