require 'digest'
require 'aws-sdk-s3'

class AlbumController < ApplicationController
  before_action :login_required
  skip_before_action :verify_authenticity_token

  def upload
    render :layout=>false
  end

  def send_cover
    al_id = "5af05c9be9e2e06cd59e8d67"
    al = Album::Album.find(al_id)
    a = al.artist
    puts "========> #{a.id}"

    aws_region = "us-east-1"
    s3 = Aws::S3::Resource.new(region:aws_region)

    obj = s3.bucket("s92-01").object("#{a.id}-#{al.id}-cover.jpeg")

    params[:files].each do |f|
      obj.upload_file(f.path)
    end
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

end
