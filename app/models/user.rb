class User < ApplicationRecord
	has_many :collections
	has_many :products
	serialize :products
	validates :user_name, :uniqueness => { :case_sensitive => false }
	validates_presence_of :user_name, :password
	has_secure_password
	accepts_nested_attributes_for :collections

	def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  
end
