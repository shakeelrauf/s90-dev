################################################################################
## rake mongo:...
################################################################################
namespace :mongo do

  task :one  => [:environment] do |t, args|
    a = Person::Artist.find("5af1ef7ee9e2e0cc397275a7")

    # al = Album::Album.create({:name=>"test album", :artist=>a})
    # puts "===> #{a.inspect}"
    #
    # puts al.inspect
    Song::Song.all.each do |s|
      s.published = 2
      s.save!
    end
  end

  task :publish => [:environment] do |t, args|
    Song::Song.each do |s|
      # s.ext = "m4a"
      # s.published = nil
      # s.save!
      #
      puts s.inspect
      s.publish
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
