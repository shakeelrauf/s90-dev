require 'digest'
require 'aws-sdk-s3'

class AlbumController < ApplicationController
  include FileUploadHandler
  include DboxClient

  # skip_before_action :verify_authenticity_token

  # my albums
  def my
    @p = load_person_required
    a = Person::Person.find(@pid)
    @albums = a.albums
    @aid = "present"
    render
  end

  def index
    @p = load_person_required
    return save if (actp == "save")
    return newr if (actp == "newr")
    return creater if (actp == "creater")
    raise "error unkown action: #{actp}"
  end

  def newr
    @album = Album::Album.new
    render :newr
  end

  def save
    album = @p.albums.find(params[:album_id])
    album.copyright = params[:field_copyright]
    album.year = params[:field_year].to_i
    album.name = params[:field_name]
    album.save!
    respond_ok
    respond_to do |format|
      if format.html
        format.html { return redirect_to artists_path }
      end
    end
  end

  def creater
    @p = load_person_required
    params[:field_year] = params[:field_year].to_i
    album = Album::Album.create({:year=>params[:field_year], :name=>params[:field_name], :artist=>@p})
    redirect_to "/al/s/#{@pid}/#{album.id}"
  end

  def songs
    @p = load_person_required
    @album = @p.albums.find(params[:alid])
  end

  # If the kind is an album include the over if stated so
  def song_names
    @p = load_person_required
    album = @p.albums.find(params[:album_id]) if (params[:album_id].present? && !params[:album_id].blank?)
    song = Song::Song.find(params[:song_id]) if (params[:song_id].present? && !params[:song_id].blank?)
    data = []
    if (album.present? && params[:include_album] == "true")
      data = [{:artist_id=>@pid, :id=>album.id.to_s, :label=>album.name, :kind=>'a'}]
      data[0][:pic] = album.cover_pic_url
    end
    h = {:data=>data}
    if (album.present?)
      album.songs.where(:published=>Constants::SONG_PUBLISHED).order("order asc").each_with_index do |s, i|
        h[:data] << map_song(s)
      end
    elsif(song.present?)
      h[:data] << map_song(song)
    end
    respond_json h
  end

  def map_song(s)
    {:artist_id=>@pid, :id=>s.id.to_s, :label=>s.title,
     :kind=>'s', :duration=>s.duration_ui, :pic=>s.album.cover_pic_url }
  end

  def cover
    @p = load_person_required
    @album = @p.albums.find(params[:alid])
  end

  # Sends the songs to dropbox
  def send_songs
    al = Album::Album.find(params["album_id"])
    a = al.artist
    songs = []
    params[:files].each do |f|
      s = Song::Song.new.init(f, a, al)
      # upload_internal(s)
      # Auto-publish supported extensions
      s.published = Constants::SONG_PUBLISHED
      s.save!
      songs.push(s)
    end
    respond_json songs
  end

  def stream_one_song
  end

  def remove_song
     s = Song::Song.find(params[:id])
     s.destroy
  end

  # def send_cover
  #   @p = load_person_required
  #   al = @p.albums.find(params["album_id"])
  #   aws_region = ENV['AWS_REGION']
  #   s3 = Aws::S3::Resource.new(region:aws_region)

  #   params[:files].each do |f|
  #     fn = f.original_filename
  #     ext = fn[fn.rindex('.')+1, fn.length]
  #     puts "========> #{ext}"
  #     al.cover_pic_name = "#{al.artist.id}-#{al.id}-cover.#{ext}"
  #     obj = s3.bucket(ENV['AWS_BUCKET']).object(al.cover_pic_name)
  #     obj.upload_file(f.path)
  #     al.save!
  #   end
  #   respond_ok
  # end

  def send_cover
    al = Album::Album.where(id: params[:id]).first
    @aid =  params[:id]
    Album::Cover.where(album_id: al.id).destroy_all
    puts "========> #{al.name}"
    album_path = "#{Rails.application.root.to_s}/tmp/album_covers#{al.id}"
    aws_region = ENV['AWS_REGION']
    FileUtils.mkdir_p album_path
    s3 = Aws::S3::Resource.new(region:aws_region)
    img = nil
    @img = al.covers.build
    @img.save
    fn = "covers_img#{@img.id}.png"
    file_name = "#{album_path}/#{fn}"
    convert_data_url_to_image( params[:files],file_name )
    obj = s3.bucket(ENV['AWS_BUCKET']).object("#{al.class.name.split("::").first.downcase}/#{al.id}/#{fn}")
    obj.upload_file(file_name)
    @img.image_name = fn
    @img.save!
    image_html = view_context.render  'images/image.html.erb'
    image =  JSON.parse(@img.to_json)
    image["image_url"] = @img.image_url
    image["image_html"] = image_html
    respond_json(image)
  end

  def rem_cover
    respond_ok
  end

  def test_aws
    n = Time.now.getutc
    d = n.strftime "%Y%m%d"
    d_iso = n.strftime "%Y%m%dT%H%M%SZ"
    aws_region = "us-east-1"
    aws_service = "s3"
    aws_request = "aws4_request"
    aws_key_id =     ENV['AWS_KEY_ID']
    aws_secret_key = ENV['AWS_SECRET_KEY']
    aws_signed_headers = "host;x-amz-content-sha256;x-amz-date"
    aws_enc = "AWS4-HMAC-SHA256"
    aws_sha_content = "UNSIGNED-PAYLOAD"
    aws_bucket = "s92-01"
    empty_str_hash = Digest::SHA256.hexdigest('')

    uri = "/test1/test2/new.jpg"
    host = "#{aws_bucket}.s3.amazonaws.com"
    qs = "uploads="
    can_req = "POST\n" +
              "#{uri}\n" +
              "#{qs}\n" +
              "host:#{host}\n" +
              "x-amz-content-sha256:#{empty_str_hash}\n" +
              "x-amz-date:#{d_iso}\n" +
              "\n" +
              "#{aws_signed_headers}\n" +
              "#{empty_str_hash}"

    puts "================= CREQ"
    puts can_req

    h1 = Digest::SHA256.hexdigest(can_req)

    string_to_sign = "#{aws_enc}\n" +
                     "#{d_iso}\n" +    # ISO8601
                     "#{d}/#{aws_region}/#{aws_service}/#{aws_request}\n" +
                     h1

    puts "================= STS 1"
    puts "#{string_to_sign}"

    date_key = hmac_sha256("AWS4#{aws_secret_key}", d)
    puts "Date key:                #{date_key}"
    date_region_key = hmac_sha256(date_key, aws_region)
    puts "Date region key:         #{date_region_key}"
    date_region_service_key = hmac_sha256(date_region_key, aws_service)
    puts "Date region service key: #{date_region_service_key}"
    signing_key = hmac_sha256(date_region_service_key, aws_request)
    puts "Signing key :            #{signing_key}"
    signature = hmac_sha256(signing_key, string_to_sign)

    puts "Signature :              #{signature}"

    auth = "#{aws_enc} Credential=#{aws_key_id}/#{d}/#{aws_region}/#{aws_service}/#{aws_request}, SignedHeaders=#{aws_signed_headers}, Signature=#{signature}"
    puts "================ AUTH 1"
    puts auth

    headers = {
      "Authorization" => "#{auth}",
      "x-amz-content-sha256": empty_str_hash,
      "x-amz-date": d_iso,
    }

    signer = Aws::Sigv4::Signer.new(
      service: 's3',
      region: 'us-east-1',
      access_key_id: aws_key_id,
      secret_access_key: aws_secret_key
    )

    signature = signer.sign_request(
      http_method: 'POST',
      url: "https://#{aws_bucket}.s3.amazonaws.com#{uri}?uploads",
      # headers: {
      #   'Abc' => 'xyz',
      # },
      body: '' # String or IO object
    )

    puts "==============> API"
    puts "==============> CAN REQUEST"
    puts "#{signature.canonical_request}"

    puts "==============> STS"
    puts "#{signature.string_to_sign}"
    puts "==============> #{signature.headers}"

    RestClient.post("https://#{aws_bucket}.s3.amazonaws.com#{uri}?uploads=", [], signature.headers) do |res, req|
      puts "#{res.body}"
    end

    respond_ok
  end

  def hmac_sha256(key, data)
    OpenSSL::HMAC.hexdigest('sha256', key, data)
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
