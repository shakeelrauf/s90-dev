class Client::ArtistController < ApplicationController
  before_action :authenticate_user

  layout 'home'
  include TourDates
  before_action :call_artist

  def artist_overview
    @artist = Person::Artist.find(params[:id])
    @songs =  @artist.songs
    @songs_a = [[],[]]
    @songs_a = @songs.each_slice((@songs.count/2).ceil).to_a if @songs.count > 0
    @venues =  near_by_events
  end

  def top_songs
    @top_songs = Api::V1::Parser.parse_songs(Song::Song.where(artist_id: @artist.id).order('played_count DESC'),current_user)
  end

  def albums

  end

  def playlists
    @playlists  =  @artist.playlists
  end

  private
  def call_artist
    @artist = Person::Artist.find(params[:id])
  end
end
