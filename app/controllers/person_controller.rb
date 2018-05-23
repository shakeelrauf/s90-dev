class PersonController < ApplicationController
  protect_from_forgery with: :exception
  before_action :login_required
  layout "application"

  def profile
  end

end
