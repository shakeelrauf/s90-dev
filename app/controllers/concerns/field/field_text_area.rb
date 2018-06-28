class FieldTextArea < FormField

  def initialize(_name, _options={})
    super(_name, FormField::TEXT_AREA, _options)
  end

  def make(obj, controller, index=nil)
    n = self.name
    v = obj[n]
    fi = index.present? ? "_#{index}" : ""
    r = (self.options[:rows].present? ? self.options[:rows] : 4)
    "<textarea rows=\"#{r}\" class=\"textarea\" name=\"field_#{n}#{fi}\" id=\"field_#{n}#{fi}\" placeholder=\"#{place_holder}\">#{v}</textarea>"
  end

  def update_obj(obj, params, controller, index=nil)
    fi = index.present? ? "_#{index}" : ""
    obj[self.name] = params["field_#{self.name}#{fi}"]
  end

end
