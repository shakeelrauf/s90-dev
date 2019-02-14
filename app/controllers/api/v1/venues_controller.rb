class Api::V1::VenuesController < ApiController

  def nearest_venues
    @venue = Venue.closest(origin: [params[:lat],params[:lng]]).limit(2)
    render_json_response({:data => @venue, :success => true}, :ok)
  end

end
