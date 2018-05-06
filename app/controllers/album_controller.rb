class AlbumController < ApplicationController

  skip_before_action :verify_authenticity_token

  def upload
    render :layout=>false
  end

  def send_cover
    params[:file].each do |f|
    end

    respond_ok
  end

end
