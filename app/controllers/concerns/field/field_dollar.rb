class Field::FieldDollar < Field::FormField

  def initialize(_name, _options={})
    super(_name, FormField::DOLLAR, _options)
  end

  def make(obj, controller, index=nil)
    n = self.name
    ph = place_holder
    v = (obj.nil? ? "" : obj["#{n}_ui"])
    fi = index.present? ? "_#{index}" : ""
    clazz = get_clazz(self.options, "field money")
    ro = self.options[:readonly] == true
    "<input type=\"text\" class=\"#{clazz}\" name=\"field_#{n}#{fi}\" id=\"field_#{n}#{fi}\" value=\"#{v}\" placeholder=\"#{ph}\" #{ro ? 'readonly' : ''}>"
  end

  def update_obj(obj, params, controller, index=nil)
    i = ((index.present?) ? "_#{index}" : "")
    page_field_name = "field_#{self.name}#{i}"
    obj[self.name] = Field::Parform.to_persistence(params[page_field_name]) if (params[page_field_name].present?)
  end

end
