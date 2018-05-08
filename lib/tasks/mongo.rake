################################################################################
## rake mongo:...
################################################################################
namespace :mongo do

  task :one  => [:environment] do |t, args|
    # Person::Person.where(:email=>"admin@patricegagnon.com").destroy_all
    # a = Person::Person.create({:first_name=>"Admin", :last_name=>"User", :email=>"admin@patricegagnon.com"})
    # a.roles = [Role::ADMIN]
    # a.make_salt
    # a.pw = a.encrypt_pw("abc")
    # a.save!
    a = Person::Artist.create({:first_name=>"Steve", :last_name=>"Hill", :email=>"steve@patricegagnon.com"})
    a.make_salt
    a.pw = a.encrypt_pw("abc")
    a.save!
  end

  task :one_album  => [:environment] do |t, args|
    a = Person::Artist.create({:first_name=>"Steve", :last_name=>"Hill"})
    puts "===> #{a.inspect}"

    al = Album::Album.new
    al.artist = a
    al.name = "Solo Recordings Volume I"
    al.date_released = Date.new(2012, 1, 1)
    al.save!


  end

end
