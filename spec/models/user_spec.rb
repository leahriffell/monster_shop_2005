require 'rails_helper'

describe User, type: :model do
  describe "validations" do
      it  { should validate_presence_of :name }
      it  { should validate_presence_of :address }
      it  { should validate_presence_of :city }
      it  { should validate_presence_of :state }
      it  { should validate_presence_of :zip }
      it  { should validate_presence_of :email }
      it  { should validate_uniqueness_of :email }
      it  { should validate_presence_of :password }
      it  { should validate_presence_of :password_confirmation }
  end

  describe "class methods" do 
    it ".email_exists?" do
      user = User.create!(name:"Luke Hunter James-Erickson", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword")

      expect(User.email_exists?("tombroke@gmail.com")).to eq(true)
      expect(User.email_exists?("anything@gmail.com")).to eq(false)
    end
  end
end
