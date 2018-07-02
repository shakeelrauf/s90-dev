################################################################################
## rake mongo:...
################################################################################
namespace :mongo do

  task :one  => [:environment] do |t, args|
  end

  task :publish => [:environment] do |t, args|
    Song::Song.where(:published.ne=>Constants::SONG_PUBLISHED).each do |s|
      puts s.inspect
      s.publish
    end
  end

  task :set_duration => [:environment] do |t, args|
    # s = Song::Song.first
    # puts s.inspect
    # s.set_duration_on_stored_file
    Song::Song.all.each do |s|
      s.set_duration_on_stored_file
      s.save!
    end
  end

  task :reindex  => [:environment] do |t, args|
    Album::Album.all.each do |a|
      a.save!
    end
    Person::Artist.all.each do |p|
      p.save!
    end
  end

end
