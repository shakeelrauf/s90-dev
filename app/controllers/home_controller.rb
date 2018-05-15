class HomeController < ApplicationController
  protect_from_forgery with: :exception
  before_action :login_required

  def index
    puts "===> 1: #{is_admin?}"
    puts "===> 1: #{is_admin?}"
    if (session[:return_url].present?)
      redirect_to session[:return_url]
    elsif(is_admin?)
      redirect_to "/al/up"
    elsif(is_artist?)
      redirect_to "/al/my/#{current_user.id}"
    end
  end
end
