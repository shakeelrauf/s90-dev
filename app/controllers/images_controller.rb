class ImagesController < ApplicationController

  def default_image
    ot =  params[:ot]
    img_id = params[:img_id]
    oid =  params[:oid]
    if ot == "person"
      p = Person::Person.find_by_id(oid)
      p.make_it_default(img_id)
      redirect_to p_path(pid: oid)
    elsif ot == "album"
      a = Album::Album.find_by_id(oid)
      a.make_it_default(img_id)
      redirect_to request.referer
    end
  end

  def get_covers
    album =  Album::Album.find_by_id(params[:id])
    @covers = album.covers
    if @covers.empty?
      images = render_to_string partial:  'images/images.html.erb', locals: {images: []}
      return respond_json({images: images})
    end
    default = @covers.select{|img| img.default == true}.first
    default = @covers.last if default.nil?
    remaining = @covers.reject{|img| img.id == default.id}
    @aid = album.id
    images = render_to_string partial:  'images/images.html.erb', locals: {images: [default] + remaining}
    respond_json({images: images})
  end

  def get_profile_pics
    person =  Person::Person.find_by_id(params[:id])
    @covers = person.images
    if @covers.empty?
      images = render_to_string partial:  'images/images.html.erb', locals: {images: []}
      return respond_json({images: images})
    end
    @pid = person.id
    default = @covers.select{|img| img.default == true}.first
    default = @covers.last if default.nil?
    remaining = @covers.reject{|img| img.id == default.id}
    images = render_to_string partial:  'images/images.html.erb', locals: {images: [default] + remaining}
    respond_json({images: images})
  end

  def del_img
    image = ImageAttachment.find_by_id(params[:id])
    return respond_ok if image.nil?
    image.destroy
    respond_ok
  end
end
