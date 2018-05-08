module SessionRole
  include Role

  def has_role?(role)
    has_session? && current_user.has_role?(role)
  end

  def is_type?(clazz)
    has_session? && current_user.class == clazz
  end

end
