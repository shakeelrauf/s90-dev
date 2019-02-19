class PersonController < ApplicationController
  protect_from_forgery with: :exception
  layout "application"

  def profile
    @p = load_person
    @default = ImageAttachment.default_pic_for(@p)
    if @default.present?
      @images = @p.images.where.not(id: @default.id)
    else
      @images =  @p.images
    end
    @albums =  @p.albums if @p.is_artist?
    if @p.id != current_user.id
      @tours = @p.tours
    end
    @venues = Venue.all
    @artist =  Person::Person.find_by_id(params[:pid])
    @tour = Tour.new
  end

end
