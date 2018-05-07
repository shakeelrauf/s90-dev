class ArtistController < ApplicationController
  protect_from_forgery with: :exception
  before_action :login_required

  def index
  end

  def search
    q = params[:q]
    h = []
    str = q.split(/[(\s|,)]/i)
    str.each do |s|
      next if s.blank?
      h << {"first_name" => Regexp.new(s, Regexp::IGNORECASE)}
      h << {"last_name" => Regexp.new(s, Regexp::IGNORECASE)}
    end
    a = []
    # Sort the by rank first, so people come up first,
    # Then the investments. Higher the rank the sooner.
    a = Artist.where('$or' => h).limit(20) if (!h.empty?)
    a = {:msg=>'ok'} if (h.empty?)
    respond_json a
  end

end
