class Person::Event < ApplicationRecord

  has_one :person,     inverse_of: :event, class_name: "Person::Person"

end
