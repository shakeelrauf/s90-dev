class Api::V1::SessionsController < ApiController
  require 'open-uri'

  def create
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if !params[:person][:password].present? and !params[:person][:email].present?
    @p =  Person::Person.where(email: params[:person][:email]).first
    if @p.present?
      if @p.encrypt_pw(params[:person][:password]) == @p.pw
        return render_json_response({:auth_token => @p.authenticated,user: Api::V1::Parser.parse_artists(@p,current_user), :success => true, msg: LOGIN_SUCCESS_MSG}, :ok)
      else
        return render_json_response({:msg => PASSWORD_INVALID_MSG, :success => false}, :ok)
      end
    else
      return render_json_response({:msg => USER_NOT_FOUND_MSG, :success => false}, :ok)
    end
  end

  def destroy
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if !params[:auth_token].present?
    @auth_token = Authentication.where(authentication_token: params[:auth_token]).first
    if @auth_token.present?
      @auth_token.destroy
      return render_json_response({:msg =>  LOGOUT_SUCCESS_MSG , :success => true}, :ok) 
    else
      return render_json_response({:msg => USER_NOT_FOUND_MSG, :success => false}, :ok) 
    end
  end

  def fb_auth_token
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if !params[:person].present? && !params[:person][:email].present?
    @p =  Person::Person.where(email: params[:person][:email]).first
    if @p.present?
      return render_json_response({:auth_token => @p.authenticated,user: Api::V1::Parser.parse_artists(@p, current_user), :success => true, msg: LOGIN_SUCCESS_MSG}, :ok)
    else
      @p = Person::Person.create(email: params[:person][:email], first_name: params[:person][:name].split(" ").first, last_name: params[:person][:name].split(" ").last, provider: params[:person][:provider], uid:  params[:person][:uid] )
      if params[:person][:profilePic].present?
        aws_region = ENV['AWS_REGION']
        profile_path = "#{Rails.application.root.to_s}/tmp/profile_pics#{@p.id}"
        FileUtils.mkdir_p profile_path
        s3 = Aws::S3::Resource.new(region:aws_region)
        @img = @p.images.build
        @img.save
        fn = "image#{@img.id}.png"
        f = open("#{profile_path}/#{fn}", 'wb') do |file|
          file << open(params[:person][:profilePic]).read
        end
        file_name = "#{profile_path}/#{fn}"
        obj = s3.bucket(ENV['AWS_BUCKET']).object("#{@p.class.name.split("::").last.downcase}/#{@p.id}/#{fn}")
        obj.upload_file("#{profile_path}/#{fn}")
        @img.image_name = fn
        @p.make_it_default(@img.id)
        @img.save!
        @p.save!
      end
      return render_json_response({:auth_token => @p.authenticated,user: Api::V1::Parser.parse_artists(@p, current_user), :success => true, msg: LOGIN_SUCCESS_MSG}, :ok)
    end
  end
end
