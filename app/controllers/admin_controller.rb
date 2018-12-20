class AdminController < ApplicationController
  before_action :login_required
  before_action :admin_required
  layout 'application'

  def artists
    @p = current_user
    @artists = Person::Artist.all.limit(100).order(created_at: :asc)
  end

  def managers
    @p = current_user
    @managers = Person::Manager.all.limit(100).order(created_at: :asc)
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
        @cfg = @p.cfg.reinit_pw
        locals = {:key=>@p.cfg.pw_reinit_key, :pid=>@p.id.to_s}
        @p.force_new_pw = true
        @p.cfg.save
        @p.save
        puts "#{root_url}/sec/pw_init/#{@p.id}/#{locals[:key]}"
        build_and_send_email("Reset password",
                             "security/pass_init_email",
                             @p.email,
                             locals,@p.language)
        respond_ok
      else
        respond_msg "not found"
      end
    else
      respond_msg "something went wrong"
    end
  end

def suspend_artist
    if params[:action]  == 'suspend_artist'
      @p = Person::Person.where(id: params[:id]).first
      if @p.present?
        if (@p.is_suspended == false)
          @p.is_suspended = true
        else 
          @p.is_suspended = false   
        end
        @p.save     
        respond_ok
      else
        respond_msg "not found"
      end
    else
      respond_msg "something went wrong"
    end
  end

def suspended_artist
    if params[:action]  == 'suspend_artist'
      @p = Person::Person.where(id: params[:id]).first
      if @p.present?
        if (@p.is_suspended == false)
          @p.is_suspended = true
        else 
          @p.is_suspended = false   
        end
        @p.save     
        respond_ok
      else
        respond_msg "not found"
      end
    else
      respond_msg "something went wrong"
    end
  end

  def i18n_files
    @fn = params[:oid]
  end

  def i18n_table
    @fn = params[:fn]
    y_fr = YAML.load(File.read("#{Rails.root}/config/locales/#{@fn}.yml"))
    @y = {}
    add_keys(y_fr, @y, '', 'fr', :fr)

    fn_en = @fn.gsub(/fr_/, 'en_')
    y_en = YAML.load(File.read("#{Rails.root}/config/locales/#{fn_en}.yml"))
    add_keys(y_en, @y, '', 'en', :en)

    # Sort
    @y = @y.sort.to_h

    render "i18n_table", :layout=>false
    true
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
      @p.cfg.save
      @p.save!
      if @invitee.present? 
        puts "invitee"
        build_and_send_email("Invite Email",
                           "emails/invitation_email",
                           @p.email,
                           locals,@p.language) if @p.email.present?
      else
        puts "new person "

        build_and_send_email("Reset password",
                           "security/pass_init_email",
                           @p.email,
                           locals,@p.language) if @p.email.present?
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

  def artist_invite
    @p = Person::Artist.new
  end

  def i18n_save
    fn_fr = params[:fn]
    fn_en = fn_fr.gsub(/fr_/, 'en_')
    # Back the files
    path_fr = "#{Rails.root}/config/locales/#{fn_fr}.yml"
    path_en = "#{Rails.root}/config/locales/#{fn_en}.yml"
    back_fr = "#{Rails.root}/config/locales/#{fn_fr}.back.yml"
    back_en = "#{Rails.root}/config/locales/#{fn_en}.back.yml"
    FileUtils.remove_file(back_fr) if (File.exists?(back_fr))
    FileUtils.remove_file(back_en) if (File.exists?(back_en))
    FileUtils.cp(path_fr, back_fr)
    FileUtils.cp(path_en, back_en)
    keys = []
    params.each do |k,v|
      keys.push k.gsub(/key\./, '') if (k.start_with?("key."))
    end
    keys = keys.sort

    # Make the master hash
    m = master_hash(keys, params)
    puts m.inspect

    # Save the files
    f_fr = File.open(path_fr, "w")
    f_en = File.open(path_en, "w")

    # Write a header
    f_fr << "# Nul nécessaire de modifier ce fichier, il est généré par l'utilitaire admin\n"
    f_en << "# Unnecessary to modify this, it's generated by the admin utility\n"
    f_fr << "fr:\n"
    f_en << "en:\n"

    # Write the master hash, first level
    write_master_hash(f_fr, m[:fr], 1)
    write_master_hash(f_en, m[:en], 1)

    # Close the files
    f_fr.close
    f_en.close

    # Remove the back files
    FileUtils.remove_file(back_fr) if (File.exists?(back_fr))
    FileUtils.remove_file(back_en) if (File.exists?(back_en))
    redirect_to "/ad/i18n_files/#{fn_fr}"
  end


  private

  def add_keys(y, h, base_key, key, lang)
    y[key].each do |k,v|
      next_base_key = "#{base_key}#{(base_key.blank? ? "" : ".")}#{k}"
      if (y[key][k].class == Hash)
        add_keys(y[key], h, next_base_key, k, lang)
      else
        h[next_base_key] = {} if (h[next_base_key].nil?)
        h[next_base_key][lang] = v
      end
    end
  end

  def master_hash(keys, params)
    base = ""
    h = {:fr=>{}, :en=>{}}
    keys.each do |key|
      a = key.split('.')
      current_hash_fr = h[:fr]
      current_hash_en = h[:en]
      a.each_with_index do |sub_key, i|
        if (i >= (a.size-1))
          # a value
          current_hash_fr[sub_key] = params["fr.#{key}"]
          current_hash_en[sub_key] = params["en.#{key}"]
        else
          # A sub-hash
          current_hash_fr[sub_key] = {} if (current_hash_fr[sub_key].nil?)
          current_hash_en[sub_key] = {} if (current_hash_en[sub_key].nil?)
          current_hash_fr = current_hash_fr[sub_key]
          current_hash_en = current_hash_en[sub_key]
        end
      end
    end
    h
  end

  def write_master_hash(f, h, level)
    h.each do |k,v|
      (1..level).each {|i| f << "  "}
      f << "#{k}:"
      if (v.class == Hash)
        f << "\n"
        write_master_hash(f, v, level+1)
      else
        f << " \"#{v}\"\n"
      end
    end
  end


  def artist_params
    params.require(:person_artist).permit(:email,:first_name, :last_name,:language)
  end

  def manager_params
    params.require(:person_manager).permit(:email,:first_name, :last_name,:language)
  end

  def build_person
    if params[:person_artist].present?
      @p = Person::Artist.new(artist_params)
      @invitee = params[:person_artist][:invitee].present? ? true : false
    elsif params[:person_manager].present?
      @p = Person::Manager.new(manager_params)
    else
      return render 'artist_new'
    end
  end
end
