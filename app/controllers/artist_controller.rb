class ArtistController < ApplicationController
  before_action :login_required

  def index
  end

  def send_pic
    @p = load_person_required
    puts "========> #{@p.name}"

    aws_region = ENV['AWS_REGION']
    s3 = Aws::S3::Resource.new(region:aws_region)

    params[:files].each do |f|
      fn = f.original_filename
      ext = fn[fn.rindex('.')+1, fn.length]
      puts "========> #{ext}"
      obj = s3.bucket(ENV['AWS_BUCKET']).object("#{@pid}-pic.#{ext}")
      obj.upload_file(f.path)
      @p.profile_pic_name = "#{@p.id}-pic.#{ext}"
      @p.save!
    end
    respond_ok
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

end
