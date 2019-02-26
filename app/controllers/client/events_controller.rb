class Client::EventsController < ClientController

  before_action :authenticate_user
  include TourDates
  include Api::V1::SongsMethods

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

  def all_events
    @events = all_tour_events_with_sort
  end

  def my_events
  end

  def like
    like_object
  end

  def dislike
    dislike_object
  end

end
