class Field::FieldHidden < Field::FormField

  def initialize(_name, _options={})
    super(_name, FormField::HIDDEN, _options)
  end

  def make(obj, controller, index=nil)
    n = self.name
    v = (obj.nil? ? "" : obj[n])
    fi = index.present? ? "_#{index}" : ""
    "<input type=\"hidden\" name=\"field_#{n}#{fi}\" id=\"field_#{n}#{fi}\" value=\"#{v}\">"
  end

  def update_obj(obj, params, controller, index=nil)
    i = ((index.present?) ? "_#{index}" : "")
    page_field_name = "field_#{self.name}#{i}"
    obj[self.name] = params[page_field_name]
  end

end
