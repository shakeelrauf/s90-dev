class ImageAttachment < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  validates :default, uniqueness: { scope: :imageable }, if: :default?

  # Methods to set/unset the default image
  def undefault!
    update(default: false)
  end

  def default!
    imageable.default_image.undefault! if imageable.default_image
    update(default: true)
  end

  def self.dummy_image
    url = ActionController::Base.helpers.asset_path 'client/temp/avatar-4.jpg'
  end

  def self.default_pic_for(person)
    images = where(imageable_id: person.id , imageable_type: "Person::Person")
    default_img = images.select{|img| img.default==true}
    default_img = default_img.last
    default_img = images.last if default_img.nil?
    default_img
  end

  def image_url
    return "#{ENV['AWS_BUCKET_URL']}/#{Constants::GENERIC_COVER}" if (self.image_name.nil?)
    u = "#{ENV['AWS_BUCKET_URL']}/#{self.imageable_type.split("::").first.downcase}/#{self.imageable_id}/#{self.image_name}"
    return u
  end
end
