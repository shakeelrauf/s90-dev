class Api::V1::Parser

  def self.parse_albums(albums)
    albums_a = []
    albums.each do |al|
      album  = JSON.parse(al.to_json)
      album["pic"] = al.cover_pic_url
      albums_a.push(album)
    end
    return albums_a
  end

  def self.parse_playlists(playlists)
    playlists_a = []
    playlists.each do |pl|
      playlist  = JSON.parse(pl.to_json)
      playlist["pic"] = pl.image_url
      playlists_a.push(playlist)
    end
    return playlists_a
  end

  def self.parse_songs(songs)
    songs_a = []
    songs.each do |s|
      song  = JSON.parse(s.to_json)
      song["title"] = s.title
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

  def self.parse_artists(artists)
    artists_a = []
    artists.each do |a|
      artist  = JSON.parse(a.to_json)
      artist["pic"] = nil
      artist["id"] =  a.id
      artist["pic"] = a.default_image.image_url if a.images.present?
      artist["name"] = nil
      artist["name"] = a.full_name
      artists_a.push(artist)
    end
    return artists_a
  end
end