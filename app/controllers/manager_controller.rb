class ManagerController < ApplicationController
	protect_from_forgery with: :exception
  before_action :login_required
  skip_before_action :verify_authenticity_token, only: [:artist_create]
  layout 'application'

  

  def artist_save
    respond_ok
  end

  def artists
    @p = current_user
    @artists = Person::Artist.any_of({manager_id: current_user.id}).limit(100).order_by(created_at: :asc)
  end

  def artist_new
    @p = Person::Artist.new
  end

  def artist_invite
    @p = Person::Artist.new
  end
  
  def person_create
    build_person
    @p.manager_id = current_user.id
    if @p.save
      @p.cfg.reinit_pw
      locals = {:key=>@p.cfg.pw_reinit_key, :pid=>@p.id.to_s}
      @p.force_new_pw = true
      @p.save!
      build_and_send_email("Reset password",
                           "security/pass_init_email",
                           @p.email,
                           locals,@p.language) if @p.email.present?
      redirect_to manager_artists_path
    else
      if  params[:person_artist][:invitee].present?
        render 'manager/artist_invite'
      else
        render 'manager/artist_new'
      end
    end
  end

  private

  def artist_params
    params.require(:person_artist).permit(:email,:first_name, :last_name)  
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
