module TourDates

  def near_by_events
    venue_points = Venue.joins(:tours).where.not(lat: nil, lng: nil).closest(origin: [cookies[:lat],cookies[:lng]]).uniq
    venues = Api::V1::Parser.venue_parser(venue_points).flatten.uniq
    venues
  end

  def nearest_events(params)
    venue = Venue.joins(:tours).where.not(lat: nil, lng: nil).closest(origin: [params[:lat],params[:lng]]).uniq.limit(2)
    venue = Api::V1::Parser.venue_parser(venue)
    venue
  end

  def all_tour_events
  	venue_points = Venue.joins(:tours).uniq
    venues = Api::V1::Parser.venue_parser(venue_points).flatten.uniq
    venues = venues.sort_by {|hh| hh["event_date"].to_date}.reverse
    events = venues.group_by {|hh| hh["event_date"].to_date.strftime("%B")}.reverse_each
    events
  end

end