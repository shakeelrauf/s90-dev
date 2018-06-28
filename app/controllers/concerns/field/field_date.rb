class FieldDate < FormField
  include ErrorCode

  def initialize(_name=FormField::DATE, _options={})
    super(_name, FormField::DATE, _options)
  end

  def make(obj, controller, index=nil)
    n = self.name
    v = (obj.nil? ? nil : obj[n])
    begin
      v = Parform.to_date(v, controller.date_parsing_format)
    rescue Exception => e
      controller.logger.error "#{P009} for field #{n}"
      raise e
    end
    clazz = (self.options[:clazz].present? ? self.options[:clazz] : "field #{css_default_class}")
    fi = index.present? ? "_#{index}" : ""
    "<input type=\"text\" class=\"#{clazz}\" id=\"field_#{n}#{fi}\" name=\"field_#{n}#{fi}\" value=\"#{v}\" placeholder=\"#{date_format_label(controller)}\">"
  end

  def update_obj(obj, params, controller, index=nil)
    i = ((index.present?) ? "_#{index}" : "")
    page_field_name = "field_#{self.name}#{i}"
    v = params[page_field_name]

    obj[self.name] = parse_date(v)
    req = self.options[:required]
    obj[self.name] = nil if (req.nil? && v.blank?)    # Dates are required by default
    obj[self.name] = nil if (req.present? && req == true && v.blank?)
  end

  def date_format_label(controller)
    controller.date_format_label
  end

  def parse_date(v)
    return nil if v.nil? || v.blank?
    begin
      raise "error" if ("%d-%m-%Y" != Constants::DATE_FORMAT_FR_CA)
      return Date.strptime(v, Constants::DATE_FORMAT_FR_CA)
    rescue Exception => e
      raise "parse_date failed with date: #{v}"
    end
  end

  def css_default_class
    return "date_field"
  end

end
