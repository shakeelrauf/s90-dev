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
      song["pic"] = nil
      song["pic"] = s.album.cover_pic_url if s.album.present?
      song["album_name"] = nil
      song["album_name"] = s.album.name if s.album.present?
      songs_a.push(song)
    end
    return songs_a
  end
end