require 'mongoid'

class Person::Event
  include Mongoid::Document

  has_one :person,     inverse_of: :event, class_name: "Person::Person"

  field :key,      type: String
  field :val,      type: String

end
