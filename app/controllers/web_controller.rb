class WebController < ApplicationController
  skip_before_action :login_required

  def index
    render :layout=>false
  end

end
