class TourDatesController < ApplicationController

	def index
    @tour_dates = TourDate.all
  end
 
  def new
    @tour_date = TourDate.new
  end
 
  def edit
    @tour_date = TourDate.find(params[:id])
  end
 
  def create
    @tour_date = TourDate.new(tour_date_params)
    @tour_date.door_time = DateTime.parse(params[:door_time])
    @tour_date.show_time = DateTime.parse(params[:show_time])
 
    if @tour_date.save
      redirect_to "/tour_dates"
    else
      render 'new'
    end
  end
 
  def update
    @tour_date = TourDate.find(params[:id])
 
    params[:door_time] = DateTime.parse(params[:door_time])
    params[:show_time] = DateTime.parse(params[:show_time])
    if @tour_date.update(tour_date_params)
      redirect_to "/tour_dates"
    else
      render 'edit'
    end
  end
 
  def destroy
    @tour_date = TourDate.find(params[:id])
    @tour_date.destroy
 
    redirect_to tour_dates_path
  end
 
  private

    def tour_date_params
      params.permit(:id, :date, :door_time, :show_time, :ticket_price, :venue_id)
    end
end
