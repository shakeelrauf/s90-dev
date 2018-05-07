module PersonRole
  include Role

  def is_admin?
    self.roles.present? && self.roles.include?(ADMIN)
  end

end
