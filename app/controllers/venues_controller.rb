class VenuesController < AdminController
	 def index
    @venues = Venue.all
  end
 
  def new
    @venue = Venue.new
  end
 
  def edit
    @venue = Venue.find(params[:id])
  end
 
  def create
    @venue = Venue.new(venue_params)
    @venue.venue_coords
    if @venue.save
      redirect_to "/venues"
    else
      render 'new'
    end
  end
 
  def update
    @venue = Venue.find(params[:id])
    @venue.venue_coords
    if @venue.update(venue_params)
      redirect_to "/venues"
    else
      render 'edit'
    end
  end
 
  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy
 
    redirect_to venues_path
  end
 
  private

    def venue_params
      params.permit(:id, :name, :address, :city, :state, :country, :postal_code, :lat, :lng)
    end
end
