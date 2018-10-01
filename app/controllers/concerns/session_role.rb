module SessionRole
  include Role

  def has_role?(role)
    has_session? && current_user.has_role?(role)
  end

  def is_type?(clazz)
    has_session? && current_user.class == clazz
  end

  def successful_login(p, email)
    # We are logged in
    # Person::Event.create({:key=>"login", :val=>"[email=#{email}]", :person=>p})
    start_session p
    #
    # if (session[:return_url].present?)
    #   redirect_to session[:return_url]
    #   session[:redirect_url] = nil
    #   return true
    # end
    # false
  end

  def start_session person
    # Preserve the return url
    ru = session[:return_url] if (session[:return_url].present?)
    reset_session
    session[:return_url] = ru
    # Default the locale to fr
    person.locale = "fr" if (person.locale.nil?)
    # I18n.locale = person.locale.to_sym  # Must be a symbol :fr

    session[:user] = person
    session[:user_id] = person.id
  end

end
