class Client::SongsController < ClientController
  include Api::V1::SongsMethods
  include DboxClient

  def playable_url
    get_song_url
  end

  def like
    like_object
  end

  def dislike
    dislike_object
  end

  def add_to_playlist
    add_song_to_playlist
  end

  def create_playlist
    new_playlist
  end

  def top_songs
    @top_songs = Api::V1::Parser.parse_songs(Song::Song.order('played_count DESC'),current_user)
  end

end
