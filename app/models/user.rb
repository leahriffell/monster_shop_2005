class User < ApplicationRecord

  validates_presence_of :name, :address, :city, :state, :zip, :password, :password_confirmation

  validates :email, uniqueness: true, presence: true

  has_secure_password

  def self.email_exists?(email)
    self.find_by(email:email) != nil
  end
end
