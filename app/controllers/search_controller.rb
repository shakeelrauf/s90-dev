class SearchController < ApplicationController
  protect_from_forgery with: :exception
  before_action :login_required

  def search
    q = params[:q]
    h = []

    str = q.split(/[(\s|,)]/i)
    str.each do |s|
      next if s.blank?
      h << {"s" => Regexp.new(s, Regexp::IGNORECASE)}
    end
    indices = SearchIndex.where('$or' => h).order("r desc, l asc").limit(50) if (!h.empty?)

    # Create the mobile search sections
    sects = {}
    indices.each do |si|
      # Artists
      if (si.artist.present?)
        sects["artists"] = {"title"=>"Artists", "data"=>[]} if (sects["artists"].nil?)
        sects["artists"]["data"] << si.l
      elsif (si.album.present?)
        sects["albums"] = {"title"=>"Albums", "data"=>[]} if (sects["albums"].nil?)
        puts "======> #{sects["albums"].inspect}"
        sects["albums"]["data"] << si.l
      end
    end

    puts "#{sects.values}"

    respond_json(sects.values)
  end

end
