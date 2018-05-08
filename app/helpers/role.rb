module Role
  ADMIN = "ADMIN"

  def is_admin?
    has_role?(Role::ADMIN)
  end

  def is_artist?
    is_type?(Person::Artist)
  end

end
