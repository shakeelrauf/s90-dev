class Api::V1::VenuesController < ApiController

  def nearest_venues
    @venue = Venue.joins(:tours).where.not(lat: nil, lng: nil).closest(origin: [params[:lat],params[:lng]]).uniq.limit(2)
    @venue = Api::V1::Parser.venue_parser(@venue)
    # @venue = Venue.closest(origin: [params[:lat],params[:lng]]).limit(2)
    render_json_response({:data => @venue.flatten, :success => true}, :ok)
  end

end
