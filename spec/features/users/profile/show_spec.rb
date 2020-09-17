require 'rails_helper'

RSpec.describe "user profile page", type: :feature do
  describe "As a logged-in user" do
    before :each do
      @user = User.create!(name:"Luke Hunter James-Erickson", address:"123 Lane", city:"Denver", state:"CO", zip:"88888", email: "chadrick@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "can see my profile data (except for password)" do
      visit "/profile"

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email)
      expect(page).to_not have_content(@user.password)
      expect(page).to_not have_content(@user.password_confirmation)
    end

    it "can link to form for editing profile data" do
      visit "/profile"

      click_link "Edit Profile"
      expect(current_path).to eq("/profile/edit")
    end

    it "can link to form for changing password" do
      visit "/profile"

      click_link "Change Password"
      expect(current_path).to eq("/profile/edit")
      expect(page).to have_content("Change Password")
    end

    it "can link to my orders page if I have orders" do 
      bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order_1 = @user.orders.create!(name: "Tommy boy", address: "1234 Street", city: "Metropolis", state: "CO", zip: 12345)
      item_order_1 = ItemOrder.create!(order: order_1, item: tire, price: tire.price, quantity: 10)
      
      visit "/profile"

      expect(page).to have_link("My Orders")
      click_link "My Orders"
      expect(current_path).to eq("/profile/orders")
    end

    it "cannot link to my orders page if I have no orders" do 
      expect(page).to_not have_link("My Orders")
    end
  end
end
