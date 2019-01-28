module Imageable
  extend ActiveSupport::Concern

  included do
    has_many :image_attachments, as: :imageable, dependent: :destroy
    alias_attribute :images, :image_attachments
    attr_accessor :image_url
  end

  def default_image
    images.find_by(default: true) || images.last
  end

  def make_it_default(id)
    images.update_all(default: false)
    images.find(id).update(default: true)
  end

end