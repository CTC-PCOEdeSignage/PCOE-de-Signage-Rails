class Playlist < ApplicationRecord
  validates_presence_of :name
  has_many :playlist_slides, -> { order(position: :asc) }
  has_many :slides, through: :playlist_slides

  accepts_nested_attributes_for :playlist_slides, allow_destroy: true
end
