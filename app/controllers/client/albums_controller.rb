class Client::AlbumsController < ClientController

  def show
    current_user = Person::Person.last
    @al = Album::Album.not_suspended.find_by_id(params[:id])
    if @al.present?
      @songs = Api::V1::Parser.parse_songs(@al.songs,current_user)
    end

  end

end
