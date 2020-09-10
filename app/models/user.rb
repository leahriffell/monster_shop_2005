class User < ApplicationRecord

  validates_presence_of :name, :address, :city, :state, :zip, :password, :password_confirmation

  validates :email, uniqueness: true, presence: true

  # validates_presence_of :password, require: true
  has_secure_password

  # private/protected?
  # def method about empty_email_field
  # end

  # private
  # def empty_fields(current_params)
  #   @pet_empty_fields = []
  #   current_params.each do |key, value|
  #     if value == ""
  #       @pet_empty_fields << key.capitalize
  #     end
  #   end
  #   @pet_empty_fields
  #   # This looks like a RUBY .reduce opportunity for creating that new array
  # end
  #
  # def empty_fields_convert
  #   empty_fields_string = String.new
  #   @pet_empty_fields.each do |field|
  #     empty_fields_string += field + ", "
  #   end
  #   empty_fields_string = empty_fields_string[0..-3].gsub("_", " ")
  #   empty_fields_string
  # end
end
