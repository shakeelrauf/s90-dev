################################################################################
## rake mongo:...
################################################################################
namespace :user do

  task :create_admin  => [:environment] do |t, args|
    p = Person::Person.new
    p.roles = [Role::ADMIN]
    

  end



end
