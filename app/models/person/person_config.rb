class Person::PersonConfig
  include Mongoid::Document

  embedded_in :person, inverse_of: :cfg, class_name: "Person::Person"

  # This is for the multi
  field :has_tracker_profile,        type: Boolean

  # The info for the password reset magic link
  field :pw_reinit_key,              type: String
  field :pw_reinit_exp,              type: DateTime

  # Account lock
  field :failed_auth_count,          type: Integer
  field :lock_until,                 type: Time
  field :lock_cause,                 type: String
  field :lock_count,                 type: Integer

  # The password reinit
  def reinit_pw
    self.pw_reinit_key = SecureRandom.hex
    self.pw_reinit_exp = Time.now + 1.day
    self.person.save!
  end

  def reinit_clear
    self.pw_reinit_key = nil
    self.pw_reinit_exp = nil
  end

  def pw_init_valid?(key)
    return false if (self.pw_reinit_key.nil? || self.pw_reinit_exp.nil?)
    return false if key.nil?
    return false if (key != self.pw_reinit_key)
    return (((Time.now <=> self.pw_reinit_exp) == -1) && (key == self.pw_reinit_key))
  end

  MAX_FAILED_AUTH_ATTEMPTS = 5
  LOCK_FOR = 60
  LOCK_FOREVER_YEARS = 10

  def register_failed_auth
    self.failed_auth_count = (self.failed_auth_count.nil? ? 1 : self.failed_auth_count + 1)

    # We have reached the max...
    if (self.failed_auth_count >= MAX_FAILED_AUTH_ATTEMPTS)
       # Lock for an hour, but only once
       if (self.lock_count.nil? || self.lock_count <= 0)
         self.lock_until = (Time.now + LOCK_FOR.minutes)
         self.lock_cause = "max failed reached"
         self.failed_auth_count = 0   # The second chance
       elsif (self.count >= 1)
         self.lock_until = (Time.now + LOCK_FOREVER_YEARS.years)
         self.lock_cause = "max failed reached twice"
       end
       self.lock_count = (self.lock_count.nil? ? 1 : self.lock_count + 1)
    end
  end

  def is_locked?
    return true if (self.lock_until.present? && self.lock_until >= Time.now)
    return false if (self.failed_auth_count.nil? || self.failed_auth_count == 0)

    if (self.failed_auth_count < MAX_FAILED_AUTH_ATTEMPTS)
      puts "***** too few failed: #{self.failed_auth_count}"
      return false
    end

    if (self.failed_auth_count >= MAX_FAILED_AUTH_ATTEMPTS)
      if (self.lock_until >= Time.now)
        puts "***** unlocking later #{self.until}"
        return true
      else
        puts "*** not locked"
        return false
      end
     end

    puts "*** not locked"
    return false
  end

  def is_locked_temporarily?
    return false if self.failed_auth_count.nil?
    if ((self.lock_until.present? ) &&
        (self.lock_count.present? && self.lock_count <= 1))
      puts "*** locked temporarily"
      return true
    end
    return false
  end

  def reset
    self.failed_auth_count = nil
    self.lock_until = nil
    self.lock_cause = nil
    self.lock_count = nil
  end

  def self.make_permanent_lock(cause)
    self.lock_cause = cause
    self.lock.until = (Time.now + LOCK_FOREVER_YEARS.years)
  end


end
