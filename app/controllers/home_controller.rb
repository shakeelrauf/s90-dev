class HomeController < ApplicationController
  protect_from_forgery with: :exception
  before_action :login_required

  def frames
    render :layout=>false
  end

  def index
    if (session[:return_url].present?)
      redirect_to session[:return_url]
    elsif(is_admin?)
      redirect_to "/ad/artists"
    elsif(is_artist?)
      # redirect_to "/al/my/#{current_user.id}"
      @next = "/al/my/#{current_user.id}"
    end
  end
end
