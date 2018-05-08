class AdminController < ApplicationController
  protect_from_forgery with: :exception
  before_action :admin_required

  def artists
    @artists = Person::Artist.all.limit(100)
    render :layout=>false
  end

  def admin_required
    return false if (!is_admin?)
  end

end
