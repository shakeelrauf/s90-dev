class Field::FieldFloat < Field::FormField

  def initialize(_name, _options={})
    super(_name, FormField::FLOAT, _options)
  end

  def make(obj, controller, index=nil)
    n = self.name
    ph = place_holder
    v = obj[n]
    clazz = (self.options[:clazz].present? ? self.options[:clazz] : "field field_float")
    fi = index.present? ? "_#{index}" : ""
    "<input type=\"text\" class=\"#{clazz}\" name=\"field_#{n}#{fi}\" id=\"field_#{n}#{fi}\" value=\"#{v}\" placeholder=\"#{ph}\">"
  end

  # Possible to blank out optional field
  # for the retirement planning page
  def update_obj(obj, params, controller, index=nil)
    i = ((index.present?) ? "_#{index}" : "")
    v = params["field_#{self.name}#{i}"]
    if (!self.options[:required].nil? &&
        self.options[:required] == false &&
        v.blank?)
      obj[self.name] = nil
      return
    end

    obj[self.name] = Field::Parform.from_float_to_persistence(v)
  end

end
