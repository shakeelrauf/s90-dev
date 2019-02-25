class Api::V1::LikesController < ApiController
  before_action :authenticate_user
  include Api::V1::SongsMethods

  def like
    like_object
  end

  def dislike
    dislike_object
  end
end
