class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def respond_json o
    respond_to do |format|
      format.json { render json: o.to_json }
    end
  end

  def respond_ok
    h = {:msg=>"ok"}
    respond_json h
  end

end
