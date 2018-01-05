class User < ApplicationRecord
	before_save :downcase_email
  before_create :create_activation_digest
	validates :name, presence: true, length: {maximum: 50}
	validates :email, presence: true, length: {maximum: 255}, format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  attr_accessor :remember_token, :activation_token

  #Returns hash digest of given string. 
  def self.digest(string)
  	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #Returns a random token
  def self.new_token
  	SecureRandom.urlsafe_base64
  end

  #Remembers a user in the database for use in persistent sessions

  def remember
  	self.remember_token = User.new_token
  	update_attribute(:remember_digest, User.digest(remember_token))
  end

  #Returns true if the given token matches the digest. 
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
  	return false if digest.nil?
  	BCrypt::Password.new(digest).is_password?(token)
  end

  #Forgets a user. Sets the remember digest to nil
  def forget
  	update_attribute(:remember_digest, nil)
  end

  def activate
    #update_attribute(:activated, true)
    #update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end


private 
  
  #Converts email to all lowercase
 def downcase_email
  self.email.downcase!
 end

 # Creates and assigns the activation token and digest. 
 def create_activation_digest
  self.activation_token = User.new_token
  self.activation_digest = User.digest(activation_token)
 end


end

