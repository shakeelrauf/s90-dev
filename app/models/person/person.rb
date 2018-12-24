require 'securerandom'

class Person::Person < ApplicationRecord
  include PersonRole
  include Imageable
  has_many :playlists,     inverse_of: :person, class_name: "Song::Playlist"

  has_one  :person_config, inverse_of: :person, class_name: "Person::PersonConfig"
  has_many :authentications, inverse_of: :person

  validates_confirmation_of :pw
  # Adds uniquely a tag
  validates :email, uniqueness: true, if: Proc.new { |p| p.email.present? }
  has_one :cfg

  scope :suspended, -> { where(is_suspended: true) }
  # before_save :generate_token

  def add_tag(t)
    self.tags = [] if self.tags.nil?
    self.tags << t if (!self.tags.include?(t))
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.name.split(' ').first
      user.last_name = auth.info.name.split(' ').last
      user.oauth_token = auth.credentials.token
      user.save!
    end
  end

  def authenticated
    a = self.authentications.build
    a.save!
    a.authentication_token
  end


  def name
    first_name.present? ? "#{first_name} #{last_name}" : last_name
  end

  def encrypt_pw(pass)
    self.make_salt if (self.salt.blank?)
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

  def oid
    self.id.to_s
  end

  def make_salt
    self.salt = SecureRandom.base64[0,10]
    self.salt
  end

  def cfg
    if (self.person_config.nil?)
      self.person_config = Person::PersonConfig.new
      self.person_config.save!
    end
    self.person_config
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
    return nil if p.nil?

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

  def re_generate_token
    self.authentication_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.where(authentication_token: random_token).exists?
    end
    self.save
  end

  def profile_pic_url
    return "#{ENV['AWS_BUCKET_URL']}/#{Constants::GENERIC_COVER}" if (self.profile_pic_name.nil?)
    u = "#{ENV['AWS_BUCKET_URL']}/#{self.profile_pic_name}"
    return u
  end


end
