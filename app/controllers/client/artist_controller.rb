class Client::ArtistController < ApplicationController
  layout 'home'

  def artist_overview
  	 @artist = Person::Artist.find(params[:id])
  end

end
