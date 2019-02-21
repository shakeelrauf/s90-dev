class Client::EventsController < ClientController

  def show
    @event = Tour.find(params[:id])
    @tour_dates = Tour.where.not(id: @event.id).where(artist_id: @event.artist.id )
  end

end
