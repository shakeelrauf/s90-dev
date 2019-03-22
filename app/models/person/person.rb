require 'securerandom'

class Person::Person < ApplicationRecord
  include PersonRole
  include Imageable
  # for like things
  include Likeable

  has_many :like_list, class_name: 'Like', inverse_of: :user, foreign_key: :user_id

  has_many :liked_songs , through: :like_list,  source: :likeable, source_type: 'Song::Song'
  has_many :liked_artists , through: :like_list,  source: :likeable, source_type: 'Person::Person'
  has_many :liked_albums , through: :like_list,  source: :likeable, source_type: 'Album::Album'
  has_many :liked_playlists , through: :like_list,  source: :likeable, source_type: 'Song::Playlist'
  has_many :tour_dates , through: :like_list,  source: :likeable, source_type: 'TourDate'

  include LikedBy

  has_many :songs,  inverse_of: :artist, class_name: "Song::Song", foreign_key: :artist_id
  has_many :albums, inverse_of: :artist, class_name: "Album::Album", foreign_key: :artist_id

  has_many :playlists,     inverse_of: :person, class_name: "Song::Playlist"
  has_one  :person_config, inverse_of: :person, class_name: "Person::PersonConfig"
  has_many :authentications, inverse_of: :person
  has_one :cfg

  validates_confirmation_of :pw
  # Adds uniquely a tag
  validates :email, uniqueness: true, if: Proc.new { |p| p.email.present? }

  scope :suspended, -> { where(is_suspended: true) }
  # before_save :generate_token

  def as_json(options = { })
    super(:only => [:first_name, :last_name,:dob,:gender, :language]).merge({
                                                        :oid=>self.oid
                                                    })
  end
  
  def likes(model)
    like = Like.find_or_initialize_by(:likeable=>model,:user_id=>self.id)
    like.save!
    like
  end

  def not_suspended_albums
    albums.not_suspended
  end

  def destroy_like(model)
    like = Like.where(likeable: model, user_id: self.id)
    like.destroy_all if like.present?
    like
  end

  def liked?(model)
    return true if !Like.where(likeable: model, user_id: self.id).empty?
    return false
  end

  def liked_model(model)
    likes =  Like.where(user_id: self.id, likeable_type: model)
    likes
  end

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