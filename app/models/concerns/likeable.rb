module Likeable
  extend ActiveSupport::Concern
  include ModelConstants

  included do
    has_many :likes, as: :likeable, dependent: :destroy
  end
  #
  # TYPES_OF_LIKES.each do |r|
  #   define_method "liked_#{r}" do
  #     model = ARTIST if r == "artists"
  #     model = ALBUM if r == "albums"
  #     model = PERSON if r == "persons"
  #     model = SONG if r == "songs"
  #     model = PLAYLIST if r == "playlists"
  #     likes = liked_model(model)
  #     likes
  #   end
  # end
end