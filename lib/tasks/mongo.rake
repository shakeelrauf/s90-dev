################################################################################
## rake mongo:...
################################################################################
namespace :mongo do

  desc "one time"
  task :one  => [:environment] do |t, args|
    a = Artist.create({:first_name=>"First", :last_name=>"Hill"})
    puts "===> #{a.inspect}"
  end

end
