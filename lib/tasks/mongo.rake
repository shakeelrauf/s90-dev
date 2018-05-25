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

    # Person::Person.where(:email=>"admin@patricegagnon.com").destroy_all
    # a = Person::Person.create({:first_name=>"Admin", :last_name=>"User", :email=>"admin@patricegagnon.com"})
    # a.roles = [Role::ADMIN]
    # a.make_salt
    # a.pw = a.encrypt_pw("abc")
    # a.save!

    # a = Person::Artist.create({:first_name=>"Steve", :last_name=>"Hill", :email=>"steve@patricegagnon.com"})
    # a.make_salt
    # a.pw = a.encrypt_pw("abc")
    # a.save!
    # al = Album::Album.new
    # al.artist = Person::Artist.find_by_email("steve@patricegagnon.com")
    # al.name = "Solo Recordings Volume I"
    # al.date_released = Date.new(2012, 1, 1)
    # al.save!
  end

  task :one_album  => [:environment] do |t, args|
    a = Person::Artist.create({:first_name=>"Steve", :last_name=>"Hill"})
    puts "===> #{a.inspect}"
  end

end
