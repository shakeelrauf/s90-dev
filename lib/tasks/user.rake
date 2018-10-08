################################################################################
## rake mongo:...
################################################################################
namespace :user do

  task :create  => [:environment] do |t, args|
    roles = []
    if (ENV['role'] == "ARTIST")
      p = Person::Artist.new
      roles = [ENV['role']]
    elsif (ENV['role'] == "ADMIN")
      p = Person::Person.new
      roles = [ENV['role']]
    else
      p = Person::Person.new
    end
    p.email = ENV['email']
    p.pw = p.encrypt_pw(ENV['pw'])
    p.first_name = ENV['fn']
    p.last_name = ENV['ln']
    p.roles = roles
    p.save!
    puts p.inspect
  end

#steve@patricegagnon.com
# abc123
end
