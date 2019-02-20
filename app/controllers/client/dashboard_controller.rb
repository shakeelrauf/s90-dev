class Client::DashboardController < ClientController

  def dashboard
  	current_user = Person::Person.last
  	@new_artists = Api::V1::Parser.parse_artists(Person::Artist.where(is_suspended: false).order('created_at DESC').limit(5), current_user)
   	@recently_played = Api::V1::Parser.parse_songs(Song::Song.order('last_played DESC').limit(5),current_user)
   	@most_played = Api::V1::Parser.parse_songs(Song::Song.order('played_count DESC').limit(10),current_user)
   	# venue_points = Venue.joins(:tours).where.not(lat: nil, lng: nil).closest(origin: [params[:lat],params[:lng]]).uniq.limit(2)
   	venue_points = Venue.joins(:tours).where.not(lat: nil, lng: nil).closest(origin: [31.4742,74.2497]).uniq.limit(2)
    @venues = Api::V1::Parser.venue_parser(venue_points)
  end

end