class Field::FieldText < Field::FormField
  
  def initialize(_name, _options={})
    super(_name, Field::FormField::TEXT, _options)
  end

  def make(obj, controller, index=nil)
    n = self.name
    ph = get_place_holder(index)
    v = (obj.nil? ? "" : obj[n])
    clazz = (self.options[:clazz].present? ? self.options[:clazz] : "field")
    fi = index.present? ? "_#{index}" : ""
    "<input type=\"text\" class=\"#{clazz}\" name=\"field_#{n}#{fi}\" id=\"field_#{n}#{fi}\" value=\"#{v}\" placeholder=\"#{ph}\">"
  end
  
  def update_obj(obj, params, controller, index=nil) 
    i = ((index.present?) ? "_#{index}" : "")
    page_field_name = "field_#{self.name}#{i}"
    obj[self.name] = params[page_field_name]
  end
  
end