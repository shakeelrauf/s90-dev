################################################################################
## rake mongo:...
################################################################################
namespace :mongo do

  task :one  => [:environment] do |t, args|
    # Song::Song.each do |s|
    #   puts s.inspect
    # end
  end

  task :publish => [:environment] do |t, args|
    Song::Song.each do |s|

      # s.ext = "m4a"
      # s.published = nil
      # s.save!
      #
      puts s.inspect
    #   s.publish
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

  task :one_album  => [:environment] do |t, args|
    a = Person::Artist.create({:first_name=>"Steve", :last_name=>"Hill"})
    puts "===> #{a.inspect}"
  end

end
