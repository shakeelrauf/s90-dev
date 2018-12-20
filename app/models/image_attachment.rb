class ImageAttachment < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  validates :default, uniqueness: { scope: :imageable }, if: :default?
  attr_accessor :image_url

  # Methods to set/unset the default image
  def undefault!
    update(default: false)
  end

  def default!
    imageable.default_image.undefault! if imageable.default_image
    update(default: true)
  end

  def image_url
    return "#{ENV['AWS_BUCKET_URL']}/#{Constants::GENERIC_COVER}" if (self.image_name.nil?)
    u = "#{ENV['AWS_BUCKET_URL']}/#{self.imageable_type.split("::").last.downcase}/#{self.imageable_id}/#{self.image_name}"
    return u
  end
end
