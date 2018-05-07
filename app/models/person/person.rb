require 'mongoid'
require 'securerandom'

class Person::Person
  include Mongoid::Document

  has_many :playlists,     inverse_of: :person, class_name: "Song::Playlist"
  # has_many :events,        inverse_of: :person, class_name: "Person::Event"
  has_one  :cfg,           inverse_of: :person, class_name: "Person::PersonConfig"

  field :first_name ,      type: String
  field :last_name,        type: String
  field :email,            type: String
  field :pw,               type: String
  field :salt,             type: String
  field :force_new_pw,     type: Boolean
  field :locale,           type: String

  field :roles,            type: Array
  field :tags,             type: Hash

  # Adds uniquely a tag
  def add_tag(t)
    self.tags = [] if self.tags.nil?
    self.tags << t if (!self.tags.include?(t))
  end

  def name
    first_name.present? ? "#{first_name} #{last_name}" : last_name
  end

  def encrypt_pw(pass)
    raise "error" if (self.salt.blank?)
    puts "==> salt2:       #{self.salt}"
    Digest::SHA1.hexdigest(pass + self.salt)
  end

  # Resets the password, return the plain text for emailing
  def reset_pw
    make_salt
    pass = SecureRandom.base64[0,6]
    self.pw = encrypt_pw(pass)
    self.force_new_pw = false
    puts pass
    pass
  end

  def make_salt
    self.salt = SecureRandom.base64[0,10]
    self.salt
  end

  def self.find_by_email(email)
    return nil if email.nil?
    where(:email=>email.downcase).first
  end

  def is_locked?
    (self.cfg.present? && self.cfg.is_locked?)
  end

  def is_locked_temporarily?
    (self.cfg.present? && self.cfg.is_locked_temporarily?)
  end

  def self.email_exists? email
    Person.where(email: email).first.present?
  end

  # Key is either the email or password
  def self.auth(key, pass)
    return nil if (key.blank? || pass.blank?)
    p = where(:email=>key.downcase.strip).first

    if p.salt.nil?
      logger.info "person with #{key} nil salt"
      return nil
    end

    # The user is valid but locked
    return p if (p.is_locked?)

    puts "==> pass:        #{pass}"
    puts "==> salt:        #{p.salt}"
    puts "==> p.pw:        #{p.pw}"
    puts "==> encrypt_pw:  #{p.encrypt_pw(pass)}"

    if (p.encrypt_pw(pass) == p.pw)
      return p
    else
      p.register_failed_auth
      p.save!
      return nil
    end
  end

  def register_failed_auth
    # Nothing here for now
  end

end
