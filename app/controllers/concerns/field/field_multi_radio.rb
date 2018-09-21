class Field::FieldMultiRadio < Field::FormField

  def initialize(_name, _options={})
    super(_name, FormField::RADIO_MULTI, _options)
  end

  # multi-value type radio buttons
  def make(obj, controller)
    r = Hash.new
    n = self.name
    vals   = self.options[:values]
    labels = self.options[:labels]
    div_class = (self.options[:div_class].nil? ? "radio" : self.options[:div_class])
    show_div = (self.options[:show_div].nil? ? true : self.options[:show_div].nil?)
    label_class = (self.options[:label_class].nil? ? "form-label" : self.options[:label_class])

    vals.each_with_index do |v,i|
      checked = (!obj[n].nil? && obj[n] == v) ? "checked=\"true\"" : ""
      r[v] = (show_div ? "<div class=\"#{div_class}\">" : "")
      r[v] =  "#{r[v]}<input type=\"radio\" name=\"field_#{n}\" id=\"field_#{n}_#{v}\" value=\"#{v}\" class=\"multi-radio\" #{checked}>" +
              "  <label class=\"\" for=\"field_#{n}_#{v}\"><span><span></span></span>#{ (labels.present? ? labels[i] : "")}</label>"
      r[v] = (show_div ? "#{r[v]}</div>" : r[v])
    end
    r
  end

  def update_obj(obj, params, controller)
    page_field_name = "field_#{self.name}"
    field = params[page_field_name]
    obj[self.name] = params[page_field_name] if (field.present?)
  end

end
