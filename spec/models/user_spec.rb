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
    it {should belong_to(:merchant).optional }
  end

  describe "roles" do
    it "can be created as an admin" do
      user = User.create!(name:"Update US26", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "penelope@gmail.com", password: "boom", password_confirmation:"boom", role: 2)
      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end

    it "can be created as a merchant user" do
      mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      user = User.create!(name:"Update US26", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "sammy@gmail.com", password: "pass", password_confirmation:"pass", role: 1, merchant_id: mike.id)
      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
    end

    it "can be created as a regular user" do
      user = User.create!(name:"Update US26", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "sammy453645@gmail.com", password_confirmation:"pass", password: "pass", role: 0)
      expect(user.role).to eq("regular")
      expect(user.regular?).to be_truthy
    end
  end

  describe "class methods" do
    it ".email_exists?" do
      user = User.create!(name:"Luke Hunter James-Erickson", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "onetwothreefourfive@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

      expect(User.email_exists?(user.email)).to eq(true)
      expect(User.email_exists?("anything@gmail.com")).to eq(false)
    end
  end

  describe "instance methods" do 
    before :each do
      @user_1 = User.create!(name:"Luke Hunter James-Erickson", address:"123 Lane", city:"Denver", state:"CO", zip:"88888", email: "chadrick@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)
      @user_2 = User.create!(name:"LHJE", address:"123 Lane", city:"Denver", state:"CO", zip:"88888", email: "chad@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

      bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order_1 = @user_1.orders.create!(name: "Tommy boy", address: "1234 Street", city: "Metropolis", state: "CO", zip: 12345)
      item_order_1 = ItemOrder.create!(order: order_1, item: tire, price: tire.price, quantity: 10)
    end

    describe ".has_orders?" do 
      it "can return true or false if user has any orders" do 
        expect(@user_1.has_orders?).to eq(true)
        expect(@user_2.has_orders?).to eq(false)
      end
    end
  end
end
