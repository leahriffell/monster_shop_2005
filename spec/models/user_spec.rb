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
      it  { should validate_presence_of :role }
  end

  describe "relationships" do
    it { should have_many :orders}
  end

  describe "roles" do
    it "can be created as an admin" do
      user = User.create(email: "penelope@gmail.com",
                         password: "boom",
                         role: 2)
      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end
    it "can be created as a merchant user" do
      user = User.create(email: "sammy@gmail.com",
                         password: "pass",
                         role: 1)
      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
    end
    it "can be created as a regular user" do
      user = User.create(email: "sammy453645@gmail.com",
                         password: "pass",
                         role: 0)
      expect(user.role).to eq("regular")
      expect(user.regular?).to be_truthy
    end
  end

  describe "class methods" do
    it ".email_exists?" do
      user = User.create!(name:"Luke Hunter James-Erickson", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

      expect(User.email_exists?(user.email)).to eq(true)
      expect(User.email_exists?("anything@gmail.com")).to eq(false)
    end
  end
end
