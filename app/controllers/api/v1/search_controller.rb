class Api::V1::SearchController < ApiController
	before_action :authenticate_user
	

	def genres
		@genres =  Song::Genre.all
		render_json_response({:genres => @genres, :success => true}, :ok)
	end


	def suggested_playlists
		@pl = Song::Playlist.where(curated: true)
		render_json_response({:pl => @pl, :success => true}, :ok)
	end


	def search
    q = params[:q]
    indices = SearchIndex.search(q).order("r asc, l asc").limit(50) if (!q.nil?)
    
    # Create the mobile search sections
    sects = {}
    sects["artists"] = [] if (sects["artists"].nil?)
    sects["albums"] = [] if (sects["albums"].nil?)
    sects["songs"] = [] if (sects["songs"].nil?)
    indices.each do |si|
      # Artists
      if (si.artist.present?)
        h = {"name"=>si.l,"id"=>si.artist.id, "pic"=>"", "artist_id"=>si.artist.id.to_s, "res_type"=>"a"}
        h["pic"] = si.artist.profile_pic_url if (si.artist.profile_pic_name.present?)
        sects["artists"] << h
      elsif (si.album.present?)
        h = {"label"=>si.l,"id"=>si.album.id, "pic"=>"", "album_id"=>si.album.id.to_s,
             "res_type"=>"al"}
        h["artist_id"] = si.album.artist.id.to_s if si.album.artist.present?

        h["pic"] = si.album.cover_pic_url
        sects["albums"] << h
      elsif (si.song.present?)  
        h = {"title"=>si.l,"id"=>si.song.id, "pic"=>"", "song_id"=>si.song.id.to_s,
             "res_type"=>"s"}
        h["artist_id"] = si.song.artist.id.to_s if si.song.artist.present?
        h["pic"] = si.song.album.cover_pic_url if si.song.album.present?
        h["album_name"] = si.song.album.name if si.song.album.present?
        sects["songs"] << h
      end
    end if (indices.present?)
		render_json_response({:data => sects, :success => true}, :ok)
  end
end
