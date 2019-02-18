class Authentication < ApplicationRecord
	belongs_to :person, inverse_of: :authentications, class_name: "Person::Person"


	before_save :generate_token

  protected
  def generate_token
    self.authentication_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.where(authentication_token: random_token).exists?
    end
  end
end
