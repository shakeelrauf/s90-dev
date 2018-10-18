# Configuration for the parameters
class ParamConfig
  DEFAULT_LENGTH = 100    # No string can come in with more than 100 chars by default, unless specified
  EMAIL_RE = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/i

  CL_STRING = 0
  CL_EMAIL = 1
  CSRF_LENGTH = Constants::CSRF_SIZE * 2
  attr_accessor :clazz
  attr_accessor :min
  attr_accessor :max
  attr_accessor :required

  def initialize(clazz, hash={})
    @clazz = clazz
    @min = hash[:min]
    @max = hash[:max]
    @required = hash[:req]
  end

  # The validation, by type
  def validate(k, v, controller)
    return if v.blank? && !required
    return if (k == "_auto_save_fields_")
    return if (controller.request.get?)

    # Validate the max length for everything
    max = (@max.nil? ? DEFAULT_LENGTH : @max)
    if (v.length > max)
      controller.logger.error "Invalid max length for parameter : #{k}, for url: #{controller.request.url}, value: [#{v}]"
      controller.logger.error "param size is #{v.length} while accepted is: #{max}"
      u = controller.current_user
      controller.logger.error "#{ErrorCode::S011}, user: #{u.present? ? u.email : 'no session'}"
      raise "Unauthorized field size DEFAULT: #{controller.request.url}, #{v.length}, Key: #{k} Value: #{v}"
    end

    if (@clazz == CL_STRING)
      # Min length
      min = (@min.nil? ? 0 : @min)
      if (v.length < min)
        controller.logger.error "Invalid min length for parameter : #{k}, for url: #{controller.request.url}, value: [#{v}]"
        controller.logger.error "param size is #{v.length} while accepted is: #{min}"
        u = controller.current_user
        controller.logger.error "#{ErrorCode::S012}, user: #{u.present? ? u.email : 'no session'}"
        raise "Unauthorized field size CL_STRING: #{controller.request.url}, #{v.length}, Key: #{k} Value: #{v}"
      end

    elsif (@clazz == CL_EMAIL)
      # Validate the email
      if (EMAIL_RE.match(v).nil?)
        controller.logger.error "Invalid email for parameter : #{k}, for url: #{controller.request.url}, value: [#{v}]"
        controller.logger.error "email is #{v}"
        u = controller.current_user
        controller.logger.error "#{ErrorCode::S013}, user: #{u.present? ? u.email : 'no session'}"
        raise "Unauthorized field size CL_EMAIL: #{controller.request.url}, #{v.length}, Key: #{k} Value: #{v}"
      end

    else
      raise "**************** unsupported class: #{@clazz}"
    end
  end

  def self.default
    ParamConfig.new(CL_STRING, {:max=>DEFAULT_LENGTH})
  end

  def self.csrf
    ParamConfig.new(CL_STRING, {:max=>Constants::CSRF_SIZE*2})
  end

end
