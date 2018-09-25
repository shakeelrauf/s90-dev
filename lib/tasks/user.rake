################################################################################
## rake mongo:...
################################################################################
namespace :user do

  task :create  => [:environment] do |t, args|
    if (ENV['role'] == "ARTIST")
      p = Person::Artist.new
    elsif (ENV['role'] == "ADMIN")
      p = Person::Person.new
    else
      raise "error, role not supported: #{ENV['role']}"
    end
    p.email = ENV['email']
    p.pw = p.encrypt_pw(ENV['pw'])
    p.first_name = ENV['fn']
    p.last_name = ENV['ln']
    p.roles = [ENV['role']]
    p.save!
    puts p.inspect
  end

#steve@patricegagnon.com
# abc123
end
