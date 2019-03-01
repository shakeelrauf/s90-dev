class Api::V1::VenuesController < ApiController
  before_action :authenticate_user
  include TourDates

  def nearest_venues
    @venue = Venue.joins(:tours).where.not(lat: nil, lng: nil).within(100, units: :kms, origin: [params[:lat],params[:lng]]).uniq.limit(2)
    @venue = Api::V1::Parser.venue_parser(@venue)
    # @venue = Venue.closest(origin: [params[:lat],params[:lng]]).limit(2)
    render_json_response({:data => @venue.flatten, :success => true}, :ok)
  end

  def all_nearest_events
    @venue = Venue.joins(:tours).where.not(lat: nil, lng: nil).order("created_at DESC").uniq
    @venue = Api::V1::Parser.venue_parser(@venue)
    render_json_response({:data => @venue.flatten, :success => true}, :ok)
  end

  def my_events
    render_json_response({:data => my_liked_events, :success => true}, :ok)
  end

  def all_events
    nearest = []
    my_events = []
    events = []
    events = all_tour_events
    if params[:lat].present? && params[:lng].present? 
      nearest = nearest_events(params)
    end
    render_json_response({:all_events => events, near_events: nearest.flatten, my_events: my_events, :success => true}, :ok)
  end

  def index
    search  = "%#{params[:search]}%"
    returned = {
        results: [],
        pagination: {
            more: false
        }
    }
    venues  =  Venue.where('name LIKE ? OR address  LIKE ? OR city LIKE ?  OR postal_code  LIKE ? OR country LIKE ? OR state LIKE ?', search, search, search, search, search, search)
    venues.each do |venue|
      t = ""
      t += venue.name + ", " if venue.name && venue.name.present?
      t += venue.city + ", " if venue.city && venue.city.present?
      t += venue.state + ", " if venue.state && venue.state.present?
      t += venue.postal_code  if venue.postal_code && venue.postal_code.present?
      returned[:results].push({id: venue.id, text: t})
    end
    respond_json(returned)
  end

end
