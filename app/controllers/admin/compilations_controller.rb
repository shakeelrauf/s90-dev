class Admin::CompilationsController < AdminController
  before_action :login_required


	def new
    genre = Genre.select("id, name").all
    @genre = genre
	end

	def create
		@compilation = Song::Compilation.new(compilation_params)
		@compilation.save!
		genres = params[:field_genre].split(',')
    genres.each do |genre|
      CompilationGenre.create(genre_id: genre, compilation_id: @compilation.id)
    end
		redirect_to admin_compilation_path(@compilation.id)
	end

	def send_song
    sc = Song::Compilation.find(params[:compilation_id])
    songs = []
    params[:files].each do |f|
      s = Song::Song.new.init(f, nil, nil, sc)
      # upload_internal(s)
      # Auto-publish supported extensions
      s.published = Constants::SONG_PUBLISHED
      s.save!
      sc.songs << s
      json_song = JSON.parse s.to_json
      json_song["duration"] = Time.at(s.duration).utc.strftime("%H:%M:%S") if s.duration.present?
    
      songs.push(json_song)
    end
    respond_json songs
  end


	def update
	end

	def edit
	end

	def show
    genre = Genre.select("id, name").all
    @genre = genre
		@compilation = Song::Compilation.find(params[:id])
    @genrez = @compilation.genres.pluck(:id).join(',')
	end

	def index
		@compilations = Song::Compilation.all
	end

	private

	def compilation_params
		params.permit(:title)		
	end
end
