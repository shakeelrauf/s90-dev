# Updates a model object from request params
module Field::FormFieldUpdater extend ActiveSupport::Concern

  def update_array(array, params, form_fields, controller)
    raise "nil array" if (array.nil?)
    raise "missing fields" if form_fields.nil?
    current_ff = nil
    begin
      i = 0
      while(true) do
        form_fields.each do |ff|
          current_ff = ff  # For the exception rendering
          return if (params["field_#{ff.name}_#{i}"].nil?)
          ff.update_obj(array[i], params, controller, i)
        end
        i += 1
      end
    rescue Exception => e
      Rails::logger.error e.message
      Rails::logger.error "Error while processing #{current_ff.name}"
      raise e
    end
  end

  # This needs to be fixed/retested
  def audit_and_update(obj, params, form_fields, controller)
    # raise "no audit param" if (params[:audit].nil?)
    # s = Audit::ChangeSession.find(params[:audit])
    # raise "no audit" if (s.nil?)
    # old_obj = Object.const_get(s.clazz).find(obj.id)
    update_obj(obj, params, form_fields, controller)
    # s.audit(old_obj, obj)
  end

  def update_obj(obj, params, form_fields, controller)
    raise "missing fields" if form_fields.nil?
    current_ff = nil
    begin
      form_fields.each do |ff|
        current_ff = ff
        ff.update_obj(obj, params, controller)
      end
    rescue Exception => e
      Rails::logger.error e.backtrace
      Rails::logger.error e.message
      Rails::logger.error "Error while processing #{current_ff.name}"
      raise e
    end
  end

end
