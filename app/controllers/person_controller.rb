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
    @tours = Tour.all
  end

end
