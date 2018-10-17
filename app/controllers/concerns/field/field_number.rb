class Field::FieldNumber < Field::FormField

  def initialize(_name, _options={})
    super(_name, FormField::NUMBER, _options)
  end

  def make(obj, controller, index=nil)
    n = self.name
    ph = place_holder
    v = (obj.nil? ? "" : obj[n])
    clazz = (self.options[:clazz].present? ? self.options[:clazz] : "field field_number")
    fi = index.present? ? "_#{index}" : ""
    "<input type=\"text\" class=\"#{clazz}\" name=\"field_#{n}#{fi}\" id=\"field_#{n}#{fi}\" value=\"#{v}\" placeholder=\"#{ph}\">"
  end

  def update_obj(obj, params, controller, index=nil)
    i = ((index.present?) ? "_#{index}" : "")
    page_field_name = "field_#{self.name}#{i}"
    obj.method("#{self.name}=").call(Field::Parform.to_persistence(params[page_field_name]).to_i) if (params[page_field_name].present?)
  end

end
