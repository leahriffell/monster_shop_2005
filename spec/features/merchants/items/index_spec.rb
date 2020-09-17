require 'rails_helper'

RSpec.describe "merchant's items index page", type: :feature do
  describe "As a logged-in merchant" do
    before :each do
      bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      
      merchant_employee = bike_shop.users.create!(name: "Grant", address: "121 Grantville St.", city: "Granville", state: "CO", zip: "34565", email: "grant@gmail.com", password: "password", password_confirmation: "password", role: 1)

      item_1 = bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      item_2 = bike_shop.items.create!(name: "Handlebar tape", description: "XYZ", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
      item_3 = bike_shop.items.create!(name: "Watch", description: "Track your times", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 5, active?: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)
    end
  end
end