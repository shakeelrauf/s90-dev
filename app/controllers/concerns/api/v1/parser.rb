class Api::V1::Parser

  def self.parse_albums(albums, current_user)
    albums_a = []
    albums.each do |al|
      album  = JSON.parse(al.to_json)
      album["liked"] = false
      album["liked"] = current_user.liked?(al)
      album["pic"] = al.cover_pic_url
      albums_a.push(album)
    end
    return albums_a
  end

  def self.parse_playlists(playlists, current_user)
    playlists_a = []
    playlists.each do |pl|
      playlist  = JSON.parse(pl.to_json)
      playlist["pic"] = pl.image_url
      playlist["liked"] = false
      playlist["liked"] = current_user.liked?(pl)
      playlists_a.push(playlist)
    end
    return playlists_a
  end

  def self.parse_songs(songs, current_user)
    songs_a = []
    songs.each do |s|
      song  = JSON.parse(s.to_json)
      song["title"] = s.title
      song["liked"] = false
      song["liked"] = current_user.liked?(s)
      song["pic"] = nil
      song["artist_id"] = nil
      song["artist_name"] = nil
      song["album_id"] = nil
      song["album_name"] = nil
      song["artist_id"] = s.artist.id if s.artist.present?
      song["artist_name"] = s.artist.name if s.artist.present?
      song["album_id"] = s.album.id if s.album.present?
      song["pic"] = s.album.cover_pic_url if s.album.present?
      song["album_name"] = s.album.name if s.album.present?
      songs_a.push(song)
    end
    return songs_a
  end

  def self.parse_artists(artists, current_user)
    artists_a = []
    if artists.is_a? ActiveRecord::Base
      artists_a = self.artist(artists, current_user)
      return artists_a
    end
    artists.each do |a|
      artists_a.push(self.artist(a, current_user))
    end
    return artists_a
  end

  def self.artist(a, current_user=nil)
    artist  = JSON.parse(a.to_json)
    artist["liked"] = false
    artist["liked"] = current_user.liked?(a) if current_user.present?
    artist["pic"] = nil
    artist["id"] =  a.id
    artist["pic"] = a.default_image.image_url if a.images.present?
    artist["name"] = nil
    artist["name"] = a.full_name
    artist
  end
end