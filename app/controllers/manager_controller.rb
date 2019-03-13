class ManagerController < AdminController
  skip_before_action :admin_required
  include PersonCreateAbility
	protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, only: [:artist_create]
  layout 'application'

  def artist_save
    respond_ok
  end

  def artists
    @p = current_user
    @artists = Person::Artist.where(manager_id: current_user.id).limit(100).order(created_at: :asc)
  end

  def artist_new
    @p = Person::Artist.new
  end

  def artist_invite
    @p = Person::Artist.new
  end

  private

  def artist_params
    params.require(:person_artist).permit(:email,:first_name, :last_name,:language)  
  end
end
