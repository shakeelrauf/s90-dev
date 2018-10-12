class AdminController < ApplicationController
  protect_from_forgery with: :exception
  before_action :login_required
  before_action :admin_required
  skip_before_action :verify_authenticity_token, only: [:artist_create]
  layout 'application'

  def artists
    @p = current_user
    @artists = Person::Artist.all.limit(100)
  end

  def all
    @p = current_user
    @artists = Person::Person.all.limit(100)
  end

  def artist_new
    @artist = Person::Artist.new
  end

  def admin_required
    return false if (!is_admin?)
  end

  def artist_save
    respond_ok
  end

  def reinitialize_password
    if params[:action]  == 'reinitialize_password'
      @p = Person::Person.where(id: params[:id]).first
      if @p.present?
        @p.force_new_pw = true
        @p.save        
        flash[:success] = "Re initialized Password"
      end
    end
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
    a = Person::Artist.new(artist_params)
    a.pw =  a.encrypt_pw("password")
    debugger
    if a.save
      redirect_to artists_path
    else
      redirect_to artist_new_path
    end
  end

  private

  def artist_params
    params.require(:person_artist).permit(:email,:first_name, :last_name)  
  end

end
