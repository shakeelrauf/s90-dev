class FieldPostal < FormField
  
  def initialize(_name, _options={})
    super(_name, FormField::POSTAL, _options)
  end

  def make(obj, controller, index=nil)
    n = self.name
    ph = place_holder
    v = obj[n]
    fi = index.present? ? "_#{index}" : ""
    return "<input type=\"text\" class=\"field field_postal\" name=\"field_#{n}#{fi}\" id=\"field_#{n}#{fi}\" value=\"#{v}\" placeholder=\"#{ph}\">"
  end

  def update_obj(obj, params, controller, index=nil) 
    i = ((index.present?) ? "_#{index}" : "")
    page_field_name = "field_#{self.name}#{i}"
    obj[self.name] = params[page_field_name]
  end
  
  
end