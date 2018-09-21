class Field::FieldRadio < Field::FormField

  def initialize(_name, _options={})
    super(_name, FormField::RADIO, _options)
  end

  def make(obj, controller)
    r = Hash.new
    n = self.name

    # .present? doesn't work for fall bool
    on_checked = (!obj[n].nil? && obj[n] == true) ? "checked=\"true\"" : ""
    clazz = (self.options[:clazz].present? ? self.options[:clazz] : "radio")

    r[:on] =  "<div class=\"#{clazz}\">" +
              "  <input type=\"radio\" name=\"field_#{n}\" id=\"field_#{n}_on\" value=\"on\" class=\"#{clazz}\" #{on_checked}>" +
              "  <label class=\"form-label\" for=\"field_#{n}_on\"><span><span></span></span>Oui</label>" +
              "</div>"

    off_checked = (!obj[n].nil? && obj[n] == false) ? "checked=\"true\"" : ""
    r[:off] = "<div class=\"#{clazz}\">" +
              "  <input type=\"radio\" name=\"field_#{n}\" id=\"field_#{n}_off\" value=\"off\" class=\"#{clazz}\" #{off_checked}> " +
              "  <label class=\"form-label\" for=\"field_#{n}_off\"><span><span></span></span>Non</label>" +
              "</div>"
    r
  end

  def update_obj(obj, params, controller)
    field = params["field_#{self.name}"]
    if (field.present?)
      obj[self.name] = (field == "on")
    end
  end

end
