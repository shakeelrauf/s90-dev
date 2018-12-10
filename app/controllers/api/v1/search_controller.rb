class Api::V1::SearchController < ApiController
	before_action :authenticate_user
	

	def genres
		@genres =  Song::Genre.all
		render_json_response({:genres => @genres.pluck(:name), :success => true}, :ok)
	end


	def suggested_playlists
		@pl = Song::Playlist.where(curated: true)
		render_json_response({:pl => @pl, :success => true}, :ok)
	end
end
