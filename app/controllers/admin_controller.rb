class AdminController < ApplicationController
  protect_from_forgery with: :exception
  before_action :login_required
  before_action :admin_required
  layout 'application'

  def artists
    @p = current_user
    @artists = Person::Artist.all.limit(100)
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
        start_session @p if current_user_id == @p.id
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
    a = Person::Artist.create({:first_name=>params[:first_name],
                               :last_name=>params[:last_name],
                               :email=>params[:email]})
    h = {"id"=>a.id.to_s}
    respond_json h
  end

end
