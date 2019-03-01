module TourDates

  def near_by_events
    venue_points = Venue.joins(:tours).where.not(lat: nil, lng: nil).within(100, units: :kms, origin: [cookies[:lat],cookies[:lng]]).uniq
    venues = Api::V1::Parser.venue_parser(venue_points, current_user).flatten.uniq
    venues
  end

  def nearest_events(params)
    venue = Venue.joins(:tours).where.not(lat: nil, lng: nil).within(100, units: :kms, origin: [params[:lat],params[:lng]]).uniq.limit(2)
    venue = Api::V1::Parser.venue_parser(venue, current_user)
    venue
  end

  def all_tour_events
    venue_points = Venue.joins(:tours).uniq
    venues = Api::V1::Parser.venue_parser(venue_points, current_user).flatten.uniq
    venues
  end

  def all_tour_events_with_sort
    venues = all_tour_events
    venues = venues.sort_by {|hh| hh["event_date"].to_date}.reverse
    events = venues.group_by {|hh| hh["event_date"].to_date.strftime("%B")}.reverse_each
    events
  end

  def my_liked_events
    liked_events_ids =  Like.where(user_id: current_user, likeable_type: "TourDate").pluck(:likeable_id)
    liked_events = Api::V1::Parser.liked_events_parser(liked_events_ids, current_user)
    liked_events
  end

end