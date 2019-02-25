class Client::EventsController < ClientController

  def show
    @event = TourDate.find(params[:id])
    @tour_dates = Tour.where.not(id: @event.id).where(artist_id: @event.tour.artist.id )
  end

end
