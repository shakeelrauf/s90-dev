class Api::V1::Artist::ArtistsController < ApiController
	before_action :authenticate_user


	def all
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:artist_id].nil?
		p = Person::Artist.where(id: params[:artist_id]).first
		return render_json_response({:msg => USER_NOT_FOUND_MSG, :success => false}, :ok) if p.nil?
 		

		data = {
			 playlists: p.playlists, albums: parse_albums(Album::Album.all), songs: parse_songs(p.songs)
		}
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, :success => true, data:  data}, :ok)
	end

	def parse_albums(albums)
		albums_a = []
		albums.each do |al|
 			album  = JSON.parse(al.to_json)
			album["cover_pic_url"] = al.cover_pic_url
			albums_a.push(album)
 		end
 		return albums_a
	end

	def parse_songs(songs)
		songs_a = []
		songs.each do |s|
 			song  = JSON.parse(s.to_json)
			song["cover_pic_url"] = s.album.cover_pic_url if s.album.present?
			songs_a.push(song)
 		end
 		return songs_a
	end
end
