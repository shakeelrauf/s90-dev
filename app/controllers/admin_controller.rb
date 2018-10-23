class AdminController < ApplicationController
  protect_from_forgery with: :exception
  before_action :login_required
  before_action :admin_required
  skip_before_action :verify_authenticity_token, only: [:artist_create]
  layout 'application'

  def artists
    @p = current_user
    @artists = Person::Artist.all.limit(100).order_by(created_at: :asc)
  end  

  def managers
    @p = current_user
    @managers = Person::Manager.all.limit(100).order_by(created_at: :asc)
  end

  def all
    @p = current_user
    @artists = Person::Person.all.limit(100)
  end

  def artist_new
    @p = Person::Artist.new
  end 

  def manager_new
    @p = Person::Manager.new
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
        @p.cfg.reinit_pw
        locals = {:key=>@p.cfg.pw_reinit_key, :pid=>@p.id.to_s}
        @p.force_new_pw = true
        @p.save
        build_and_send_email("Reset password",
                           "security/pass_init_email",
                           @p.email,
                           locals)        
        respond_ok 
      else
        respond_msg "not found"
      end
    else
      respond_msg "something went wrong"
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

  def person_create
    build_person
    if @p.save
      @p.cfg.reinit_pw
      locals = {:key=>@p.cfg.pw_reinit_key, :pid=>@p.id.to_s}
      @p.force_new_pw = true
      @p.save!
      if !current_user.is_manager?
        build_and_send_email("Reset password",
                           "security/pass_init_email",
                           @p.email,
                           locals)
      end
      if params[:person_artist].present?
        redirect_to artists_path
      elsif params[:person_manager].present?
        redirect_to managers_path
      end
    else
      if params[:person_artist].present?
        render 'artist_new'
      elsif params[:person_manager].present?
        render 'manager_new'
      end 
    end
  end

  private

  def artist_params
    params.require(:person_artist).permit(:email,:first_name, :last_name)  
  end

  def manager_params
    params.require(:person_manager).permit(:email,:first_name, :last_name)  
  end

  def build_person
    if params[:person_artist].present?
      @p = Person::Artist.new(artist_params)
    elsif params[:person_manager].present?
      @p = Person::Manager.new(manager_params)
    else
      return render 'artist_new'
    end
  end
end
