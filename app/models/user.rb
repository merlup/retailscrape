class User < ApplicationRecord
	before_create :generate_authentication_token!
	has_many :collections
	has_many :products
	serialize :products
	serialize :api_keys
	has_many :api_keys
	validates :user_name, :uniqueness => { :case_sensitive => false }
	validates_presence_of :user_name, :password
	validates :auth_token, uniqueness: true
	has_secure_password
	accepts_nested_attributes_for :collections



	

	def generate_authentication_token!
	    begin
	      self.auth_token = SecureRandom.urlsafe_base64
	    end while self.class.exists?(auth_token: auth_token)
	  end

	def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  
end
