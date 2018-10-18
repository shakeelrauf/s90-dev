class Field::FieldDropdown < Field::FormField

  def initialize(_name, _options={})
    super(_name, FormField::DROPDOWN, _options)
  end

  def make(obj, controller, index=nil)
    n = self.name
    values = []
    values = self.options[:values] if (self.options[:values].present?)
    value_range = self.options[:value_range]
    value = obj[n] if obj.present?
    style = (self.options[:style].present?) ? self.options[:style] : ""
    # the field index, for arrays
    fi = index.present? ? "_#{index}" : ""
    s = "\n<select name=\"field_#{n}#{fi}\" id=\"field_#{n}#{fi}\" class=\"#{get_clazz}\">"
    if (!first_item.nil?)
      s = "#{s}\n<option value=\"\" disabled #{(value.nil? ? "selected" : "")}>#{first_item}</option>"
    end

    # Make the values of the range
    if (value_range.present?)
      raise "Missing value_prefix with value_range" if self.options[:value_prefix].nil?
      value_range.each do |i|
        # to_s, allows for integers
        selected = (value.to_s == i.to_s) ? "selected" : ""
        i18n = "#{self.options[:value_prefix]}#{i}"
        s = "#{s}\n<option value=\"#{i}\" #{selected}>#{I18n.t(i18n)}</option>"
      end

    else
      # Old style...
      values.each do |k,v|
        # to_s, allows for integers
        selected = (value.to_s == k.to_s) ? "selected" : ""

        # Different kinds...
        if(v.class == Hash)
          value_text = v[:label_fr]
        elsif(v.class == I18nKey)
          value_text = I18n.t(v.key)
        else
          value_text = v
        end
        s = "#{s}\n<option value=\"#{k}\" #{selected}>#{value_text}</option>"
      end
    end

    # Always do that
    s = "#{s}</select>"
    s
  end

  def update_obj(obj, params, controller, index=nil)
    i = ((index.present?) ? "_#{index}" : "")
    obj[self.name] = params["field_#{self.name}#{i}"]
  end

  def first_item
    fi = self.options[:first]
    return nil if fi.nil?
    return fi if (fi == "")
    return I18n.t(fi.key) if (fi.class == I18nKey)
    return (fi.class == Hash && fi[:label_fr].present? ? fi[:label_fr] : fi)
  end

  def get_clazz
    (self.options[:clazz].present?) ? self.options[:clazz] : "select"
  end

  def validate_values
    values = self.options[:values]
    value_range = self.options[:value_range]
    raise "Missing values or range option in DROPDOWN type" if values.nil? && value_range.nil?
  end

end
