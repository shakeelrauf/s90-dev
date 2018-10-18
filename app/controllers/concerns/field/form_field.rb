class Field::FormField

  attr_accessor :name
  attr_accessor :kind
  attr_accessor :options

  TEXT        =  0
  NUMBER      =  1
  RADIO       =  2     # Boolean on/off, see profile/infos_perso
  FILE        =  3
  DROPDOWN    =  4
  DOLLAR      =  5
  EMAIL       =  6
  RADIO_MULTI =  7
  DATE        =  8
  FLOAT       =  9
  TEXT_AREA   = 10
  POSTAL      = 11
  PHONE       = 12
  CHECKBOX    = 13
  HIDDEN      = 99

  def initialize(name, kind=TEXT, options={})
    @name=name
    @kind=kind
    @options=options
  end

  def place_holder
    # Setup the place holder
    # Uses both the legacy :label_fr kind, or the YML style
    pho = self.options[:placeholder]
    return I18n.t(pho.key) if (pho.present? && pho.class == I18nKey)
    return (pho.class == Hash && pho[:label_fr].present? ? pho[:label_fr] : pho) if (pho.present?)
  end

  # The place holder, the index will be present for an array
  def get_place_holder(index)
    pho = self.options[:placeholder]
    return nil if pho.nil?
    return pho if (pho.class == String)
    return I18n.t(pho.key) if (pho.class == I18nKey)
    # Deprecated old style
    return pho[index][:label_fr] if (index.present?)
    return pho[:label_fr]
  end

  def get_clazz(options, default)
    return options[:clazz] if (options[:clazz].present?)
    return "#{default} #{options[:clazz_add]}" if (options[:clazz_add].present?)
    return default
  end

end
