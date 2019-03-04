class Api::V1::Parser

  def self.parse_albums(albums, current_user=nil)
    albums_a = []
    if albums.is_a? ActiveRecord::Base
      albums_a = self.album(albums, current_user)
      return albums_a
    end
    albums.each do |al|
      albums_a.push(self.album(al, current_user))
    end
    return albums_a
  end


  def self.album(al, current_user=nil)
    album  = JSON.parse(al.to_json)
    album["pic"] = "#{ENV['AWS_BUCKET_URL']}/#{Constants::GENERIC_COVER}"
    album["artist_name"] = al.artist.first_name + " " + al.artist.last_name
    album["liked"] = false
    album["liked"] = current_user.liked?(al)
    album["pic"] = "#{ENV['AWS_BUCKET_URL']}/#{Constants::GENERIC_COVER}"
    album["pic"] = al.default_image.image_url if al.images.present?
    album
  end

  def self.parse_playlists(playlists, current_user)
    playlists_a = []
    if playlists.is_a? ActiveRecord::Base
      playlists_a = self.playlist(playlists, current_user)
      return playlists_a
    end
    playlists.each do |s|
      playlists_a.push(self.playlist(s, current_user))
    end
    return playlists_a
  end



  def self.parse_songs(songs, current_user=nil)
    songs_a = []
    if songs.is_a? ActiveRecord::Base
      songs_a = self.song(songs, current_user)
      return songs_a
    end
    songs.each do |s|
      songs_a.push(self.song(s, current_user))
    end
    return songs_a
  end

  def self.parse_artists(artists, current_user=nil)
    artists_a = []
    if artists.is_a? ActiveRecord::Base
      artists_a = self.artist(artists, current_user)
      return artists_a
    end
    artists.each do |a|
      artists_a.push(self.artist(a, current_user))
    end
    return artists_a
  end

  def self.venue_parser(venues, current_user=nil)
    venues_a = []
    venues.each do |a|
      venues_a.push(venue_artists(a, current_user))
    end
    return venues_a
  end

  def self.venue_artists(venue, current_user=nil)
    data = {}
    venue_data = []
    venue.tours.order("show_time desc").each do |tour|
      tour.events.order("show_time desc").each do |event|
        data["address"] = venue.address
        data["city"] = venue.city
        data["state"] = venue.state
        data["country"] = venue.country
        data["tour_name"] = tour.name
        data["show_time"] = tour.show_time
        data["id"] =  tour.artist.id
        data["tour_id"] =  tour.id
        data["pic"] = "#{ENV['AWS_BUCKET_URL']}/#{Constants::GENERIC_COVER}"
        data["pic"] = tour.artist.default_image.image_url if tour.artist.images.present?
        data["venue_name"] = venue.name
        data["artist_name"] = tour.artist.full_name
        data["event_id"] = event.id
        data["event_date"] = event.date
        data["event_door_time"] = event.door_time
        data["event_show_time"] = event.show_time
        data["event_ticket_price"] = event.ticket_price
        data["event_name"] = event.name
        data["liked"] = false
        data["liked"] = current_user.liked?(event) if current_user.present?
        venue_data << data
        data = {}
      end
    end
    venue_data.flatten
  end

  def self.artist(a, current_user=nil)
    artist  = JSON.parse(a.to_json)
    artist["liked"] = false
    artist["liked"] = current_user.liked?(a) if current_user.present?
    artist["id"] =  a.id
    artist["pic"] = ""
    artist["pic"] = a.default_image.image_url if a.images.present?
    artist["name"] = nil
    artist["name"] = a.full_name
    artist
  end

  def self.liked_events_parser(event_ids, current_user=nil)
    liked_a = []
    tours = TourDate.where(id: event_ids)
    tours.each do |a|
      liked_a.push(liked_event(a, current_user))
    end
    return liked_a
  end

  def self.liked_event(event, current_user)
    data = {}
    data["address"] = event.tour.venue.address
    data["city"] = event.tour.venue.city
    data["state"] = event.tour.venue.state
    data["country"] = event.tour.venue.country
    data["tour_name"] = event.tour.name
    data["show_time"] = event.tour.show_time
    data["id"] =  event.tour.artist.id
    data["tour_id"] =  event.tour.id
    data["pic"] = "#{ENV['AWS_BUCKET_URL']}/#{Constants::GENERIC_COVER}"
    data["pic"] = event.tour.artist.default_image.image_url if event.tour.artist.images.present?
    data["venue_name"] = event.tour.venue.name
    data["artist_name"] = event.tour.artist.full_name
    data["event_id"] = event.id
    data["event_date"] = event.date
    data["event_door_time"] = event.door_time
    data["event_show_time"] = event.show_time
    data["event_ticket_price"] = event.ticket_price
    data["event_name"] = event.name
    data["liked"] = false
    data["liked"] = current_user.liked?(event) if current_user.present?
    data
  end

  def self.playlist(pl, current_user=nil)
    playlist  = JSON.parse(pl.to_json)
    playlist["pic"] = "#{ENV['AWS_BUCKET_URL']}/#{Constants::GENERIC_COVER}"
    playlist["pic"] = pl.songs.first.present? ? pl.songs.first.album.present? ? pl.songs.first.album.image_url :  '' : ''
    playlist["liked"] = false
    playlist["songs_count"] = pl.songs.count
    playlist["liked"] = current_user.liked?(pl) if current_user.present?
    playlist
  end

  def self.song(s,current_user=nil)
    song  = JSON.parse(s.to_json)
    song["title"] = s.title
    song["liked"] = false
    song["liked"] = current_user.liked?(s)
    song["pic"] = "#{ENV['AWS_BUCKET_URL']}/#{Constants::GENERIC_COVER}"
    song["duration"] = s.duration if !s.duration.nil?
    song["artist_id"] = nil
    song["artist_name"] = nil
    song["album_id"] = nil
    song["album_name"] = nil
    song["artist_id"] = s.artist.id if s.artist.present?
    song["artist_name"] = s.artist.name if s.artist.present?
    song["album_id"] = s.album.id if s.album.present?
    song["pic"] = s.album.image_url if s.album.present? && s.album.covers.present?
    song["genre"] = s.album.genres.first.name if s.album.genres.present?
    song["album_name"] = s.album.name if s.album.present?
    song
  end
end