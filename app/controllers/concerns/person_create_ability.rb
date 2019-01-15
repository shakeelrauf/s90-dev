module PersonCreateAbility
  def person_create
    build_person
    if @p.save
      @p.cfg.reinit_pw
      locals = {:key=>@p.cfg.pw_reinit_key, :pid=>@p.id.to_s}
      @p.force_new_pw = true
      @p.cfg.save
      @p.save!
      # if @invitee.present?
      puts "invitee"
      build_and_send_email("Invite Email",
                           "emails/invitation_email",
                           @p.email,
                           locals,@p.language) if @p.email.present?
      # else
      #   puts "new person "
      #
      #   build_and_send_email("Reset password",
      #                      "security/pass_init_email",
      #                      @p.email,
      #                      locals,@p.language) if @p.email.present?
      # end
      if params[:person_artist].present?
        redirect_to "/ad/artists"
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
  def build_person
    if params[:person_artist].present?
      @p = Person::Artist.new(artist_params)
      # @invitee = params[:person_artist][:invitee].present? ? true : false
    elsif params[:person_manager].present?
      @p = Person::Manager.new(manager_params)
    else
      return render 'artist_new'
    end
  end
end