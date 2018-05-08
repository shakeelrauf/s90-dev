module PersonRole
  include Role

  def has_role?(role)
    self.roles.present? && self.roles.include?(role)
  end

  def is_type?(clazz)
    self.class == clazz
  end

end
