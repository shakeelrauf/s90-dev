################################################################################
## rake mongo:...
################################################################################
namespace :mongo do

  task :one  => [:environment] do |t, args|
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
