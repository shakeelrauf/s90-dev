module Role
  ADMIN = "ADMIN"
  ARTIST = "Person::Artist"
  MANAGER = "Person::Manager"
  LISTENER = "Person::Person"

  def is_admin?
    has_role?(ADMIN)
  end

  def is_artist?
    is_type?(ARTIST)
  end
  def is_manager?
    is_type?(MANAGER)
  end
  def is_listener?
    is_type?(LISTENER)
  end

end
