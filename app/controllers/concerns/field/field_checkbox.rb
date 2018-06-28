class FieldCheckbox < FormField
  include ErrorCode

  def initialize(_name, _options={})
    super(_name, FormField::CHECKBOX, _options)
  end

  def make(obj, controller, index=nil)
    n = self.name
    v = obj[n]
    clazz = get_clazz(self.options, "")
    c = "checked=\"true\""
    fi = index.present? ? "_#{index}" : ""
    fv = (self.options[:field_value].present? ? self.options[:field_value] : "true")
    f = "<input type=\"checkbox\" class=\"checkbox #{clazz}\"" +
    " id=\"field_#{n}#{fi}\" name=\"field_#{n}#{fi}\" value=\"#{fv}\" #{(v ? c : nil)}"
    f += "data-key-code=\"#{self.options[:key_code]}\"" if (self.options[:key_code].present?)
    f +="\>"
    f
  end

  def update_obj(obj, params, controller, index=nil)
    i = ((index.present?) ? "_#{index}" : "")
    page_field_name = "field_#{self.name}#{i}"
    obj[self.name] = (params[page_field_name].present?)
  end

end
