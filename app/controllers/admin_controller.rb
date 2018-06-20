class AdminController < ApplicationController
  protect_from_forgery with: :exception
  before_action :admin_required

  def artists
    @artists = Person::Artist.all.limit(100)
  end

  def admin_required
    return false if (!is_admin?)
  end

  def artist_save
    respond_ok
  end

  def artist
    if (params[:action] == 'validate_email')
    else
      raise "error: #{params[:action]}"
    end
  end

  def validate_email
    re = Regexp.new(params["email"], Regexp::IGNORECASE)
    a = Person::Person.where(:email=>re).first
    respond_ok if a.nil?
    respond_msg "exists" if a.present?
  end

  def artist_create
    a = Person::Artist.create({:first_name=>params[:first_name],
                               :last_name=>params[:last_name],
                               :email=>params[:email]})
    h = {"id"=>a.id.to_s}
    respond_json h
  end

end
