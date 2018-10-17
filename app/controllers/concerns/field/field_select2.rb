class Field::FieldSelect2 < Field::FieldDropdown

  def initialize(_name, _options={})
    super(_name, _options)
  end

  def get_clazz
    c = "select2"
    c += " " + self.options[:clazz] if (self.options[:clazz].present?)
    c
  end

  # Do nothing here, the values come from AJAX
  def validate_values
  end

  def make(obj, controller, index=nil)
    self.options[:values] = (self.options[:values].present? ? self.options[:values] : {})
    if (self.options[:value_none].present?)
      n = self.name
      self.options[:values][""] = self.options[:value_none]
    end
    super(obj, controller, index)
  end

end
