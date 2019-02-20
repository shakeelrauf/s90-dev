class Client::DashboardController < ClientController
	layout 'home'
  before_action :authenticate_user
  include Api::V1::MsgConstants
  include Api::V1::ArtistsMethods

  def dashboard
  	@new_artists = Api::V1::Parser.parse_artists(Person::Artist.where(is_suspended: false).order('created_at DESC').limit(5), current_user)
   	@recently_played = Api::V1::Parser.parse_songs(Song::Song.order('last_played DESC').limit(5),current_user)
   	@most_played = Api::V1::Parser.parse_songs(Song::Song.order('played_count DESC').limit(10),current_user)
   	# venue_points = Venue.joins(:tours).where.not(lat: nil, lng: nil).closest(origin: [params[:lat],params[:lng]]).uniq.limit(2)
   	venue_points = Venue.joins(:tours).where.not(lat: nil, lng: nil).closest(origin: [31.4742,74.2497]).uniq.limit(2)
    @venues = Api::V1::Parser.venue_parser(venue_points)
  end

  def get_profile
    profile_of_artist
  end

  def search
  	q = params[:q]
    indices = SearchIndex.search(q).order("r asc, l asc").limit(50) if (!q.nil?)
    
    # Create the mobile search sections
    @sects = {}
    @sects["artists"] = [] if (@sects["artists"].nil?)
    @sects["albums"] = [] if (@sects["albums"].nil?)
    @sects["songs"] = [] if (@sects["songs"].nil?)
    indices.each do |si|
      # Artists
      if (si.artist.present?)
        h = {"name"=>si.l,"id"=>si.artist.id, "pic"=>"", "artist_id"=>si.artist.id.to_s, "res_type"=>"a"}
        h["pic"] = si.artist.default_image.image_url if (si.artist.images.present?)
        h["liked"] = false
        h["liked"] = current_user.liked?(si.artist) if si.artist.present?
        @sects["artists"] << h
      elsif (si.album.present?)
        if si.album.is_suspended == false
          h = {"name"=>si.l,"id"=>si.album.id, "pic"=>"", "album_id"=>si.album.id.to_s,
             "res_type"=>"al"}
          h["artist_id"] = si.album.artist.id.to_s if si.album.artist.present?
          h["artist_name"] = si.album.artist.name.to_s if si.album.artist.present?
          h["pic"] = si.album.cover_pic_url
          h["liked"] = false
          h["liked"] = current_user.liked?(si.album) if si.album.present?
          @sects["albums"] << h
        end
      elsif (si.song.present?)  
        h = {"title"=>si.l,"id"=>si.song.id, "pic"=>"", "song_id"=>si.song.id.to_s,
             "res_type"=>"s"}
        h["artist_id"] = si.song.artist.id.to_s if si.song.artist.present?
        h["artist_name"] = si.song.artist.name.to_s if si.song.artist.present?
        h["pic"] = si.song.album.cover_pic_url if si.song.album.present?
        h["album_name"] = si.song.album.name if si.song.album.present?
        h["album_id"] = si.song.album.id if si.song.album.present?
        h["liked"] = false
        h["liked"] = current_user.liked?(si.song) if si.song.present?
        @sects["songs"] << h
      end
    end if (indices.present?)
  end

end