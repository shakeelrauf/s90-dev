# Parser/Formatter
class Parform

  # Converts a number to the persistence format: 100000.00
  # Used for money format
  def self.to_persistence(n)
    return nil if n.nil?
    n.gsub!(/\s/, '')
    # Determine if it's a CDN number
    g = n.scan Constants::CAD_NUM_REGEX
    if (g.size > 0 && g[0].size > 0)
      return g[0][0].gsub(/,/, '.').gsub(/\s/, '').to_f
    end
    g = n.scan Constants::US_NUM_REGEX
    if (g.size > 0 && g[0].size > 0)
      # it is
      return g[0][0].gsub(/,/, '').to_f
    end
    raise "error, could not parse number to persistence: #{n}"
  end

  # Keep only two decimals
  def self.to_money_persistence(n)
    return nil if n.nil?
    i = to_persistence(n)
    ("%.02f" % i).to_f
  end

  # Converts a number to the persistence format: 100000.00
  # From a float form 2.5 or 2,5
  def self.from_float_to_persistence(n)
    return nil if n.nil?
    # Determine if it's a CDN number
    g = n.scan Constants::CAD_FLOAT_REGEX
    if (g.size > 0 && g[0].size > 0)
      return g[0][0].gsub(/,/, '.').gsub(/\s/, '').to_f
    end
    g = n.scan Constants::US_FLOAT_REGEX
    if (g.size > 0 && g[0].size > 0)
      # it is
      return g[0][0].gsub(/,/, '').to_f
    end
    raise "error, could not parse float to persistence: #{n}"
  end


  # Converts a persisted number to the cdn
  # The value is a float
  def self.to_cdn_num(f)
    return "" if f.blank?
    # Keep only two dec
    n = "#{("%.02f" % f)}"
    # extract the main
    g = n.scan(/^((?:-?\d+|-?\d{1,3}(?:,\d{3})+))?((?:\.\d*))?$/)
    if (g.size > 0 && g[0].size > 0)
      main = g[0][0].to_s.gsub(/\D/, '').reverse.gsub(/.{3}/, '\0 ').reverse
      dec = g[0][1] if g[0].size > 1  # There are decimals
      dec = "#{dec}0" if dec.length < 3
      return "#{main}#{dec}".gsub(/\./, ',').strip
    end
  end

  # Strip the cents
  def self.to_cdn_dollar(f)
    n = "#{f}"
    # extract the main
    g = n.scan(/^((?:-?\d+|-?\d{1,3}(?:,\d{3})+))?((?:\.\d*))?$/)
    if (g.size > 0 && g[0].size > 0)
      main = g[0][0].to_s.gsub(/\D/, '').reverse.gsub(/.{3}/, '\0 ').reverse
      return "#{main}".gsub(/\./, ',').strip
    end
  end

  # Accounting dollars are () when negative
  def self.to_acc_cdn_dollar(f)
    str = to_cdn_dollar(f.abs)
    (f>=0) ? str : "(#{str})"
  end

  # Add the dollar sign
  def self.to_cdn_money(n, add_sign=true)
    "#{to_cdn_num(n)}#{add_sign ? '$' : ''}"
  end

  # Accounting dollars are () when negative
  def self.to_acc_cdn_money(f)
    str = to_cdn_money(f.abs, false)
    (f>=0) ? str : "(#{str})"
  end

  def self.to_date(d, format=Constants::DATE_FORMAT_FR_CA)
    d.blank? ? "" : d.strftime(format)
  end

end
