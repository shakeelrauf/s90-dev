class DefaultController < ApplicationController
	skip_before_action :login_required

  def index
    redirect_to "/default/alert.html"
  end
end