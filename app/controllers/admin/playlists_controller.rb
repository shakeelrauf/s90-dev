class Admin::PlaylistsController < AdminController
	before_action :build_playlist, only: [:new]
	before_action :find_playlist, only: [:edit, :update]
	
	def new
		render :form
	end

	def create
		@pl =  Song::Playlist.new(playlist_params)
		@pl.person =  current_user
		@pl.save!
		redirect_to admin_playlists_path
	end

	def index
		@playlists =  Song::Playlist.all
	end

	def edit
		render :form
	end

	def update
		@pl.update(playlist_params)
		redirect_to admin_playlists_path
	end

	private
	def playlist_params
		params.require(:song_playlist).permit(:title, :subtitle, :image_url, :curated)
	end

	def find_playlist
		@pl =  Song::Playlist.find(params[:id])
	end
	
	def build_playlist
		@pl = current_user.playlists.build 
	end
end
