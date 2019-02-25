class Client::SongsController < ClientController
  layout 'home'

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

  def sticky_player
    s = Song::Song.where(id: params[:sid])
    render partial: 'client/shared/sticky_player', locals: {song: s.first, songs_list: s}
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
