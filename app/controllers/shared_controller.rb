class SharedController < ApplicationController
  # protect_from_forgery with: :exception
  skip_before_action :login_required

  def token
    render :layout=>false
  end

end
