class FieldDropdownPerson < FieldDropdown

  def update_obj(obj, params, controller, index=nil)
    # Strip the _id
    foreign_key = self.name[0, self.name.length-3]
    i = ((index.present?) ? "_#{index}" : "")
    # The [] doesn't work
    p = "field_#{self.name}#{i}"
    obj.send("#{foreign_key}=", Person.find(params[p])) if (params[p].present?)
  end

end
