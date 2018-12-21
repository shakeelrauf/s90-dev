module PersonRole
  include Role

  def has_role?(role)
    self.roles.present? && self.roles.include?(role)
  end

  def is_type?(clazz)
    self.class.name == clazz
  end

  def is_artist?
    is_type?("Person::Artist")
  end

end
