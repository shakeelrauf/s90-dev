################################################################################
## rake mongo:...
################################################################################
namespace :user do

  task :create  => [:environment] do |t, args|
    p = Person::Person.new
    p.email = ENV['email']
    p.pw = p.encrypt_pw(ENV['pw'])
    p.first_name = ENV['fn']
    p.last_name = ENV['ln']
    p.roles = [ENV['role']]
    p.save!
    puts p.inspect
  end

end
