class SharedController < ApplicationController
  # protect_from_forgery with: :exception

  def token
    render :layout=>false
  end

end
