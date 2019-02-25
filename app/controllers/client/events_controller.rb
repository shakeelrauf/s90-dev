class Client::EventsController < ClientController

  def show
    @event = TourDate.find(params[:id])
    # @tour_dates = Tour.where.not(id: @event.id).where(artist_id: @event.tour.artist.id )
    @tour_dates = TourDate.where.not(id: @event.id).where(tour_id: @event.tour.id)
  end

  def index
    venues = near_by_events
    venues = venues.sort_by {|hh| hh["event_date"].to_date}.reverse
    @events = venues.group_by {|hh| hh["event_date"].to_date.strftime("%B")}.reverse_each
  end

  private

  def near_by_events
    venue_points = Venue.joins(:tours).where.not(lat: nil, lng: nil).closest(origin: [cookies[:lat],cookies[:lng]]).uniq
    @venues = Api::V1::Parser.venue_parser(venue_points).flatten.uniq
    @venues
  end
 
end
