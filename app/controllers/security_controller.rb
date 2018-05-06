class SecurityController < ApplicationController
  protect_from_forgery with: :exception

  def login
    render :layout=>false
  end

end
