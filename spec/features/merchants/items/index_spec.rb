require 'rails_helper'

RSpec.describe "merchant's items index page", type: :feature do
  describe "As a logged-in merchant" do
    before :each do
      @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      
      merchant_employee = @bike_shop.users.create!(name: "Grant", address: "121 Grantville St.", city: "Granville", state: "CO", zip: "34565", email: "grant@gmail.com", password: "password", password_confirmation: "password", role: 1)

      @item_1 = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @item_2 = @bike_shop.items.create!(name: "Handlebar tape", description: "XYZ", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
      @item_3 = @bike_shop.items.create!(name: "Watch", description: "Track your times", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 5, active?: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)
    end

    it "can all my items and their info" do 
      visit "/"
      click_on "My Items"
      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
      
      within("#item-#{@item_1.id}") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_1.description)
        expect(page).to have_content(@item_1.price)
        expect(page).to have_css("img[src*='#{@item_1.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@item_1.inventory}") 
      end

      within("#item-#{@item_2.id}") do
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content(@item_2.description)
        expect(page).to have_content(@item_2.price)
        expect(page).to have_css("img[src*='#{@item_2.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@item_2.inventory}") 
      end


      within("#item-#{@item_1.id}") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_1.description)
        expect(page).to have_content(@item_1.price)
        expect(page).to have_css("img[src*='#{@item_6.image}']")
        expect(page).to have_content("Inactive")
        expect(page).to have_content("Inventory: #{@item_1.inventory}") 
      end

#       As a merchant employee
# When I visit my items page
# I see all of my items with the following info:

# name
# description
# price
# image
# active/inactive status
# inventory
# I see a link or button to deactivate the item next to each item that is active
# And I click on the "deactivate" button or link for an item
# I am returned to my items page
# I see a flash message indicating this item is no longer for sale
# I see the item is now inactive
    end
  end
end