class Api::V1::SearchController < ApiController
	before_action :authenticate_user
	include Api::V1::SearchMethods

	def genres
		@genres =  Song::Genre.all
		render_json_response({:genres => @genres, :success => true}, :ok)
	end


	def suggested_playlists
		@pl = Song::Playlist.where(curated: true)
		render_json_response({:pl => @pl, :success => true}, :ok)
	end


	def search
    sects = {}
    sects = search_results(params)
		render_json_response({:data => sects, :success => true}, :ok)
  end
end
