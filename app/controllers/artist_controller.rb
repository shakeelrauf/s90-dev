require 'rmagick'
require 'fileutils'

class ArtistController < ApplicationController
  before_action :login_required

  def index
  end

  def send_pic
    @p = load_person_required
    puts "========> #{@p.name}"

    aws_region = ENV['AWS_REGION']
    s3 = Aws::S3::Resource.new(region:aws_region)
    img = nil
    params[:files].each do |f|
      fn = f.original_filename
      ext = fn[fn.rindex('.')+1, fn.length]
      puts "========> #{ext}"
      obj = s3.bucket(ENV['AWS_BUCKET']).object("#{@p.class.name.split("::").last.downcase}/#{@pid}/#{fn}")
      obj.upload_file(f.path)
      img = @p.images.build(image_name: fn)
      img.save
      @p.save!
    end
    image =  JSON.parse(img.to_json)
    image["image_url"] = img.image_url
    respond_json(image)
  end

  def send_pic_base64
    @p = load_person_required
    puts "========> #{@p.name}"
    profile_path = "#{Rails.application.root.to_s}/tmp/profile_pics#{@p.id}"
    aws_region = ENV['AWS_REGION']
    FileUtils.mkdir_p profile_path
    s3 = Aws::S3::Resource.new(region:aws_region)
    img = nil
    @img = @p.images.build
    @img.save
    fn = "image#{@img.id}.png"
    file_name = "#{profile_path}/#{fn}"
    convert_data_url_to_image( params[:files],file_name )
    obj = s3.bucket(ENV['AWS_BUCKET']).object("#{@p.class.name.split("::").first.downcase}/#{@pid}/#{fn}")
    obj.upload_file(file_name)
    @img.image_name = fn
    @img.save!
    image_html = view_context.render  'images/image.html.erb'
    image =  JSON.parse(@img.to_json)
    image["image_url"] = @img.image_url
    image["image_html"] = image_html
    respond_json(image)
  end

  def remove_pic
    respond_ok
  end

  def search
    q = params[:q]
    h = []
    str = q.split(/[(\s|,)]/i)
    str.each do |s|
      next if s.blank?
      h << {"first_name" => Regexp.new(s, Regexp::IGNORECASE)}
      h << {"last_name" => Regexp.new(s, Regexp::IGNORECASE)}
    end
    a = []
    # Sort the by rank first, so people come up first,
    # Then the investments. Higher the rank the sooner.
    a = Artist.where('$or' => h).limit(20) if (!h.empty?)
    a = {:msg=>'ok'} if (h.empty?)
    respond_json a
  end

  private

  def convert_data_url_to_image(data_url, file_name)
    file_name = "#{file_name}"
    imageDataString = data_url
    file = File.open("#{file_name}", "wb") {|f| f.write(Base64.decode64(imageDataString["data:image/png;base64,".length .. -1])
    )}
    return file
  end


end
