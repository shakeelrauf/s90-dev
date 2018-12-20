class PersonController < ApplicationController
  protect_from_forgery with: :exception
  before_action :login_required
  layout "application"

  def profile
    @p = load_person
    @images = @p.images
  end

end
