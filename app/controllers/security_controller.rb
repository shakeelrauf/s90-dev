class SecurityController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, :only => [:log_js_error, :log_content_sec]

  # From the login page
  def auth
    p = Person::Person.new
    update_obj(p, params, LOGIN_FIELDS, self)
    puts "======> #{p.inspect}"
    p = Person::Person.auth(p.email.strip,  p.pw.strip)

    if (p.nil?)
      @msg = "Identifiant ou mot de passe invalide."
      respond_msg(@msg)
    elsif (p.is_locked?)
      @u = p
      # render "sec/account_locked"
      respond_ok
    elsif (p.force_new_pw)
      start_session p
      # render "sec/change_password"
      respond_ok
    else
      successful_login(p, p.email)
      respond_ok
    end

  end

  def login
    session[:return_url] = params[:return_url] if (params[:return_url])
    # To avoid the session ping to start
    @fields = make_fields(OpenStruct.new, LOGIN_FIELDS, self)

    render :layout=>false
  end

  # Processes a successful login
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

  # For the OAuth server app
  def logout
    end_session
    return redirect_to "/" if (params[:return_url].nil?)
    return redirect_to params[:return_url] if (params[:return_url].present?)
  end

  def ping
    if (!has_session? || (has_session? && is_session_expired?))
      end_session
      return respond_error("expired")
    end
    return respond_ok
  end

  def forgot_pw
    f = [FieldText.new("username")]
    @fields = make_fields(OpenStruct.new(:username=>params["username"]), f, self)
  end

  def forgot_reset
    e = params["field_username"]
    p = Person::Person.find_by_email(e)
    if (p.present?)
      p.cfg.reinit_pw
      locals = {:key=>p.cfg.pw_reinit_key, :pid=>p.id.to_s}
      p.save!
      build_and_send_email("Réinitialisation de votre mot de passe",
                           "security/pass_init_email",
                           p.email,
                           locals)
    else
      logger.info("Forgot password person not found: " + e)
    end
  end

  # The pw change
  def change_pw_save
    @p = current_user
    pw = params["pw_new"]
    pw_confirm = params["pw_confirm"]
    # Validate the pw match
    if (pw != pw_confirm)
      msg = "Password and confirm dont match #{pw} and #{pw_confirm}"
      logger.info msg
      BadRequest.record_unauth self, msg
      return redirect_to("/pub/error")
    end
    # Validate the pw size
    if (pw.size < 8)
      msg = "Password too short: #{pw}"
      logger.info msg
      BadRequest.record_unauth self, msg
      return redirect_to("/pub/error")
    end
    # Validate the pw contains a CAP
    cap_re = /[A-Z]/
    if (cap_re.match(pw).nil?)
      msg = "Password doesnt contain a cap #{pw}"
      logger.info msg
      BadRequest.record_unauth self, msg
      return redirect_to("/pub/error")
    end
    # Validate the pw contains a CAP
    num_re = /[0-9]/
    if (num_re.match(pw).nil?)
      msg = "Password doesnt contain a number #{pw}"
      logger.info msg
      BadRequest.record_unauth self, msg
      return redirect_to("/pub/error")
    end

    p1 = params["field-nouveau-passe"]
    p2 = params["field-confirmer-passe"]
    if p1 != p2
      return redirect_to("/pub/error")
    end

    @p.force_new_pw = false
    # @p.cfg.reinit_clear
    @p.salt = @p.make_salt if (@p.salt.nil? || @p.salt.blank?)
    @p.pw = @p.encrypt_pw(pw)
    @p.save!
    start_session @p
    redirect_to "/security/pw_changed"
  end

  # The password of a user has been reinit by mistake
  # revert this situation
  def pw_init
    p = Person::Person.find(params[:person])
    key = params[:key]
    if (!p.cfg.pw_init_valid?(key))
      end_session    # Ensure there's no session here
      redirect_to "/security/pw_init_invalid"
      return
    end
    start_session p
    render "security/change_password"
  end

  def pw_init_revert
    p = Person::Person.find(params[:person])
    key = params[:key]
    p.cfg.reinit_clear
    p.save!
    end_session
    redirect_to "/security/pw_init_reverted"
  end

  def pw_init_invalid
    # Nothing here for now
  end

  # Password changed confirmation
  def pw_changed
    @p = load_person
  end

  # The session timeout ping
  def ping
    if (!has_session? || (has_session? && is_session_expired?))
      end_session
      return respond_error("expired")
    end
    return respond_ok
  end

  # Content-Security-Policy errors
  # Known plugins can be ignored
  KNOWN_FAILS = [
    "https://glganltcs.space",
    "eval",
    "https://eluxer.net",
    "https://datds.net",
    "https://worldnaturenet.xyz",
  ]

  def log_content_sec
    # Send me that...
    body = request.body.read.html_safe
    return if (body.nil? || body.strip.blank?)

    j = JSON.parse(body)
    report = j['csp-report']
    KNOWN_FAILS.each do |pl|
      if (report['blocked-uri'].start_with?(pl))
        logger.error "#{ErrorCode::P002} #{pl} discovered"
        respond_ok
        return
      end
    end

    logger.error "#{ErrorCode::P002} #{body}"
    logger.error "#{current_user.email}" if (has_session?)
    logger.error "ADN_CSP #{ENV['ADN_CSP']}"
    logger.error "#{request.ip}"
    logger.error "#{request.headers["user-agent"]}"

    locals = {:msg =>body,
              :ip=>request.ip,
              :agent=>request.headers["user-agent"],
              :user=> (has_session? ? current_user.email : "No session")}
    if (is_production?)
      build_and_send_email("Content-Security-Policy failure",
                           "admin/platform_email",
                           "patrice@patricegagnon.com",
                           locals)
    end
    respond_ok
  end

  def log_js_error
    logger.error "#{ErrorCode::P005} #{current_user.email}" if (has_session?)
    logger.error "#{request.ip}"
    logger.error "#{request.headers["user-agent"]}"
    logger.error "#{params[:m]}"
    logger.error "#{params[:l]}"

    content = "header: #{request.headers["user-agent"]}<br>"
    content += "m: #{params[:m]}<br>"
    content += "l: #{params[:l]}<br>"

    puts "======> content: #{content}"

    email_error("JS error", content)
    respond_ok
  end

  def timeout
    render :layout=>false
  end

  LOGIN_FIELDS =
    [Field::Text.new("email"),
     Field::Password.new("pw") ]

end
