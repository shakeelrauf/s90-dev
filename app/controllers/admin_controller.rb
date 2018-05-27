class AdminController < ApplicationController
  protect_from_forgery with: :exception
  before_action :admin_required

  def artists
    @artists = Person::Artist.all.limit(100)
  end

  def admin_required
    return false if (!is_admin?)
  end

end
