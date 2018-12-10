class Api::V1::Songs::GenresController < ApiController
	before_action :authenticate_user


	def index
		@genres =  Song::Genre.all
		render_json_response({:genres => @genres.pluck(:name), :success => true}, :ok)
	end
end
