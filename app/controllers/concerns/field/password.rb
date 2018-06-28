class Field::Password < Field::Text

  def initialize(_name, _options={})
    super(_name, _options)
  end

  def input_type
    "password"
  end

end
