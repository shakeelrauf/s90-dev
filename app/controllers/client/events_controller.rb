class Client::EventsController < ClientController
  layout 'home'

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
    @events = event_sorting(venues)
  end

  def all_events
    @events = all_tour_events_with_sort
  end

  def my_events
    liked_events = my_liked_events
    @events = event_sorting(liked_events)
  end

  def like
    like_object
  end

  def dislike
    dislike_object
  end

  private

  def event_sorting(events)
    events = events.sort_by {|hh| hh["event_date"].to_date}.reverse
    events = events.group_by {|hh| hh["event_date"].to_date.strftime("%B")}.reverse_each
    events
  end

end
