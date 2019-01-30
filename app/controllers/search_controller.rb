class SearchController < ApplicationController
  protect_from_forgery with: :exception

  def search
    q = params[:q]
    h = []

    str = q.split(/[(\s|,)]/i)
    str.each do |s|
      next if s.blank?
      h << {"s" => Regexp.new(s, Regexp::IGNORECASE)}
    end
    indices = SearchIndex.where('$or' => h).order("r asc, l asc").limit(50) if (!h.empty?)

    # Create the mobile search sections
    sects = {}

    indices.each do |si|
      # Artists
      if (si.artist.present?)
        sects["artists"] = {"title"=>"Artists", "data"=>[]} if (sects["artists"].nil?)
        h = {"label"=>si.l, "pic"=>"", "artist_id"=>si.artist.id.to_s, "res_type"=>"a"}
        h["pic"] = si.artist.profile_pic_url if (si.artist.profile_pic_name.present?)
        sects["artists"]["data"] << h
      elsif (si.album.present?)
        sects["albums"] = {"title"=>"Albums", "data"=>[]} if (sects["albums"].nil?)
        h = {"label"=>si.l, "pic"=>"", "album_id"=>si.album.id.to_s,
             "res_type"=>"al", "artist_id"=>si.album.artist.id.to_s}
        h["pic"] = si.album.cover_pic_url
        sects["albums"]["data"] << h
      end
    end if (indices.present?)

    respond_json(sects.values)
  end

end
