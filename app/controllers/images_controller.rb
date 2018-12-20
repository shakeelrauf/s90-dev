class ImagesController < ApplicationController

  def default_image
    ot =  params[:ot]
    img_id = params[:img_id]
    oid =  params[:oid]
    if ot == "person"
      p = Person::Person.find_by_id(oid)
      p.make_it_default(img_id)
      redirect_to p_path(pid: oid)
    end
  end

  def del_img
    image = ImageAttachment.find(params[:id])
    image.destroy
    respond_ok
  end
end
