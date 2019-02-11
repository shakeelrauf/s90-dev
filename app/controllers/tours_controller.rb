class ToursController < ApplicationController
  def index
    @artist =  Person::Person.find_by_id(params[:pid])
    @tours = @artist.present? ? @artist.tours : Tour.all 
  end
 
  def new
    @artist =  Person::Person.find_by_id(params[:pid])
    @tour = Tour.new
  end
 
  def edit
    @artist =  Person::Person.find_by_id(params[:pid])
    @tour = Tour.find(params[:id])
  end
 
  def create
    @tour = Tour.new(tour_params)
 
    if @tour.save
      redirect_to tours_path(pid: params[:artist_id])
    else
      render 'new'
    end
  end
 
  def update
    @tour = Tour.find(params[:id])
    artist_id = @tour.artist_id
    if @tour.update(tour_params)
      redirect_to tours_path(pid: artist_id)
    else
      render 'edit'
    end
  end
 
  def destroy
    @tour = Tour.find(params[:id])
    artist_id = @tour.artist_id
    @tour.destroy
 
    redirect_to tours_path(pid: artist_id)
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
