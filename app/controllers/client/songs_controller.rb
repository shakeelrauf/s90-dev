class Client::SongsController < ClientController
  include Api::V1::SongsMethods

  def get_playable_url
    get_song_url
  end
end
