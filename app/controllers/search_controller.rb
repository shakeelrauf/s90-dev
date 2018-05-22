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
    si = SearchIndex.where('$and' => h).order("r desc, l asc").limit(20) if (!h.empty?)
    respond_json(si)
  end

end
