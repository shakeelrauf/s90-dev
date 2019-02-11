class ToursController < ApplicationController
  def index
    @tours = Tour.all
  end
 
  def new
    @artist =  Person::Person.find_by_id(params[:pid])
    @tour = Tour.new
  end
 
  def edit
    @tour = Tour.find(params[:id])
  end
 
  def create
    @tour = Tour.new(tour_params)
 
    if @tour.save
      redirect_to "/tours"
    else
      render 'new'
    end
  end
 
  def update
    @tour = Tour.find(params[:id])
 
    if @tour.update(tour_params)
      redirect_to "/tours"
    else
      render 'edit'
    end
  end
 
  def destroy
    @tour = Tour.find(params[:id])
    @tour.destroy
 
    redirect_to tours_path
  end
 
  def del_tour
    @tour = Tour.find(params[:id])
    @tour.destroy
  end
 
  private

    def tour_params
      params.permit(:id, :name, :door_time, :show_time, :ticket_price, :artist_id, :venue_id)
    end
end
