module Field::FormFields extend ActiveSupport::Concern

  def make_fields(obj, fields, controller)
    raise "error, obj is nil, can't go anywhere" if (obj.nil?)
    raise "error missing fields" if (fields.nil?)
    ret = Hash.new
    fields.each do |f|
      ret[f.name] = f.make(obj, controller)
    end
    ret
  end

  def make_fields_array(array, fields, controller, max_size=nil)
    raise "error missing fields" if (fields.nil?)
    ret = Array.new
    return ret if (max_size.nil? && array.size == 0)

    max_index = (max_size.present? ? max_size : array.size)
    (0..max_index-1).each do |index|
      field_set = Hash.new
      fields.each do |f|
        field_set[f.name] = f.make(array[index], controller, index)
      end
      ret << field_set
    end
    ret
  end

  # This is used statically
  def self.make_dd_values(list, prefix)
    h = {}
    list.map{|i| h[i] = I18nKey.new("#{prefix}#{i}")}
    h
  end

end
