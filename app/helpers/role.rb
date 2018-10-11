module Role
  ADMIN = "ADMIN"

  def is_admin?
    has_role?("Role::ADMIN")
  end

  def is_artist?
    is_type?(Person::Artist)
  end
  def is_manager?
    is_type?(Person::Manager)
  end
  def is_listener?
    is_type?(Person::Person)
  end

end
