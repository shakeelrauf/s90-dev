class Song::Playlist < ApplicationRecord

  belongs_to :person,  inverse_of: :playlists, class_name: "Person::Person"
  has_many :song_playlists, class_name: "Song::PlaylistSong", foreign_key: 'song_playlist_id'
  has_many :songs, through: :song_playlists
  include LikedBy

  before_save :check_image

  def check_image
    n = (self.image_url.blank? ? Constants::GENERIC_COVER : self.image_url)
   	if songs.count > 0
   		self.image_url =  songs.first.album.present? ? songs.first.album.cover_pic_url : "#{ENV['AWS_BUCKET_URL']}/#{n}"
   	else
   		self.image_url = "#{ENV['AWS_BUCKET_URL']}/#{n}"
   	end
  end
end
