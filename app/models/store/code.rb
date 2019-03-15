require 'barby'
require 'barby/barcode'
require 'barby/barcode/qr_code'
require 'barby/outputter/png_outputter'

class Store::Code < ApplicationRecord

  belongs_to :album , class_name: "Album::Album"
  def image_url
    return "#{ENV['AWS_BUCKET_URL']}/#{Constants::GENERIC_COVER}" if (self.image_name.nil?)
    u = "#{ENV['AWS_BUCKET_URL']}/#{self.image_name}"
    return u
  end

  def redeemed?
    self.redeemed
  end
  
  

  def create_qr_code(ot)
    generate_token
    qr_code_path = "#{Rails.application.root.to_s}/tmp/qr_codes_#{self.token.to_s}"
    file_name = "#{ qr_code_path}/qr_code.png"
    aws_region = ENV['AWS_REGION']
    s3 = Aws::S3::Resource.new(region:aws_region)
    req = {"code"=>self.token, "ot" => ot}
    req_into_json = req.to_json
    barcode = Barby::QrCode.new(req_into_json, level: :q, size: 10)
    base64_output = Base64.encode64(barcode.to_png({ xdim: 5 }))
    Dir.mkdir(qr_code_path)
    convert_data_url_to_image(base64_output,file_name )
    obj = s3.bucket(ENV['AWS_BUCKET']).object("qr_codes_#{self.token.to_s}/qr_code.png")
    obj.upload_file(file_name)
    self.image_name = "qr_codes_#{self.token.to_s}/qr_code.png"
    self.save
  end
  private

  def self.create_code_for_release(release)
    req = {"release"=>release}
    req_into_json = req.to_json
    barcode = Barby::QrCode.new(req_into_json, level: :q, size: 10)
    base64_output = Base64.encode64(barcode.to_png({ xdim: 5 }))
    "data:image/png;base64, "  +base64_output.split("images/").last
  end

  def convert_data_url_to_image(data_url, file_path)
    file_path = "#{file_path}"
    imageDataString = data_url
    file = File.open("#{file_path}", "wb") do |f|
      f.write(Base64.decode64(imageDataString))
    end
    return file
  end

  def generate_token
    token = Digest::SHA1.hexdigest([Time.now, rand].join)
    self.token = token
    self.redeemed = false
  end
end
