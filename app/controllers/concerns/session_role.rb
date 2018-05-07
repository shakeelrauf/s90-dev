module SessionRole
  include Role

  def is_admin?
    has_session? && current_user.is_admin?
  end

end
