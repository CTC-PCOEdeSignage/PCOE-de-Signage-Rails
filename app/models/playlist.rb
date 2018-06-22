class Playlist < ApplicationRecord
  has_many :playlist_slides, -> { order(position: :asc) }, inverse_of: :playlist
  has_many :slides, through: :playlist_slides, dependent: :destroy
  has_many :screens, dependent: :nullify

  validates_presence_of :name
  validates_uniqueness_of :name

  accepts_nested_attributes_for :playlist_slides, allow_destroy: true
end
