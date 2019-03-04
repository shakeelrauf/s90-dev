module Clients::ArtistHelper

  def artist_cover(artist)
    val = "#{ENV['AWS_BUCKET_URL']}/#{Constants::GENERIC_COVER}"
    if artist.images.present? 
      val = artist.default_image.image_url
    end
    val
  end

end