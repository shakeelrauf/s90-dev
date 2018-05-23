class ApplicationController < ActionController::Base
  include SessionRole
  include Postmarker

  protect_from_forgery with: :exception
  helper_method :is_artist?, :is_admin?
  layout false
  before_action PreFilter

  # Ensures the user is in the session
  def login_required
    u = current_user
    if (!u.nil?)

      # The new session timeout
      if (has_session? && is_session_expired?)
        end_session
        redirect_to "/sec/login"
        return false
      end

      logger.info("Auth successful")

      # @p = u
      # @pid = u.id.to_s
      # I18n.locale = "fr".to_sym

      # Ensure the force pw
      if u.force_new_pw
        render "sec/change_password"
      elsif u.is_locked?
        render "sec/account_locked"
      elsif (session[:return_url].present?)
        puts "=======> session[:return_url]: #{session[:return_url]} "
        redirect_to session[:return_url]
        session[:return_url] = nil
      end

      # Default the expiration
      set_session_expiration(u)

      # We're good
      return true
    elsif (request.get?)
      # I18n.locale = "fr".to_sym
      # No user, keep the return url
      session[:return_url] = request.url
    end

    logger.info("Auth NOT successful, sending to login")
    redirect_to "/sec/login"
    return false
  end

  def load_person_required
    raise "missing param" if (params[:pid].blank?)
    @p = Person::Person.find(params[:pid])
    @pid = @p.id.to_s
    @p
  end

  def load_person
    @p = Person::Person.find(params[:pid]) if (params[:pid].present?)
    @p = current_user if (params[:pid].nil?)
    @pid = @p.id.to_s
    @p
  end

  def set_session_expiration(u)
    session[:expires_at] = Time.current + 60.minutes
  end

  def is_session_expired?
    (session[:expires_at].present? && session[:expires_at] < Time.current)
  end

  def end_session
    reset_session
    session[:user] = nil
    session[:user_id] = nil
    session[:return_url] = nil
  end

  def has_session?
    session[:user].present?
  end

  def current_user
    session[:user]
  end
  helper_method :current_user

  def current_user_id
    session[:user_id]
  end
  helper_method :current_user_id

  def current_user_email
    (current_user.present? ? current_user.email : nil)
  end

  def current_username
    (current_user.present? ? current_user.username : nil)
  end

  def locale
    if (current_user.nil? || current_user.locale.nil?)
      return :fr
    end
    current_user.locale_sym
  end

  # Returns the js path for a url
  def js_path
    pub_path("js")
  end

  def css_path
    pub_path("css")
  end

  # The path of a css or js file
  def pub_path(ex)
    u = request.url
    g = u.scan Constants::PATH_REGEX
    return nil if g.size == 0
    return nil if g[0].size == 0
    p = g[0][1]

    # p looks like /a/b/12345
    g2 = p.scan(/([a-z][^\/]*)/)
    return nil if g2.size == 0
    return nil if g2[0].size == 0
    # return /a
    pub_root =  "#{Rails.root}/public"
    if g2.size == 1
      p1 = "/s92/#{ex}/pages/#{g2[0][0]}.#{ex}"
      return p1 if (File.exists?("#{pub_root}#{p1}"))
    elsif g2.size >= 2
      p2 = "/s92/#{ex}/pages/#{g2[0][0]}/#{g2[1][0]}.#{ex}"
      return p2 if (File.exists?("#{pub_root}#{p2}"))
    end
    if g2.size >= 3
      p3 = "/s92/#{ex}/pages/#{g2[0][0]}/#{g2[1][0]}/#{g2[2][0]}.#{ex}"
      return p3 if (File.exists?("#{pub_root}#{p3}"))
    end
    nil
  end

  def email_error(s, other_content="")
    content = other_content
    # The exception message
    if ($!.present?)
      content += "Exception message: #{$!} <br>"
      content += "<br>"
    end
    # The stack trace
    if ($@.present?)
      $@.each do |i|
        content += "#{i}<br>"
      end
    end
    email_info(s, content)
  end

  def email_info(s, other_content=nil)
    content = "<html>"
    content += "===> URL :   #{request.url} <br>"
    content += "===> Method: #{request.method} <br>"
    content += "===> IP:     #{request.ip} <br>"
    if (has_session?)
      content += "===> Name:   #{current_user.name} <br>"
      content += "===> Pid:    #{current_user_id} <br>"
      content += "===> Email:  #{current_user.email} <br>"
    end
    content += "<br>"
    content += "#{other_content}<br>"

    # The navigation
    if (has_session? && session[:nav].present?)
      content += "Navigation:<br>"
      session[:nav].each do |n|
        content += "#{n}<br>"
      end
    end

    content += "</html>"
    send_email(s, content, "patrice@patricegagnon.com")
  end

  def respond_json o
    respond_to do |format|
      format.json { render json: o.to_json }
    end
  end

  def respond_ok
    respond_msg('ok')
  end

  def respond_msg(msg)
    h = {:res=>msg}
    respond_json h
  end

  def respond_error(error)
    h = {:res=>"error",:msg=>error}
    respond_json h
  end

  # Responds with a 403 error code
  def respond_forbidden
    render :status => :forbidden, :plain => "accès non authorisé. IP: #{request.ip}"
  end

end
