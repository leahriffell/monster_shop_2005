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

      visit "/"
      click_on "My Items"
    end

    it "can all my items and their info" do       
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


      within("#item-#{@item_3.id}") do
        expect(page).to have_content(@item_3.name)
        expect(page).to have_content(@item_3.description)
        expect(page).to have_content(@item_3.price)
        expect(page).to have_css("img[src*='#{@item_3.image}']")
        expect(page).to have_content("Inactive")
        expect(page).to have_content("Inventory: #{@item_3.inventory}") 
      end
    end

    it "can deactive an active item" do 
      within("#item-#{@item_1.id}") do
        click_button "Deactivate"
      end

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{@item_1.name} is no longer for sale")

      within("#item-#{@item_1.id}") do
        expect(page).to have_content("Inactive")
        expect(page).to have_button("Activate")
      end
    end

    it "can activate an inactive item" do 
      within("#item-#{@item_3.id}") do
        click_button "Activate"
      end

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{@item_3.name} is now available for sale")

      within("#item-#{@item_3.id}") do
        expect(page).to have_content("Active")
        expect(page).to have_button("Deactivate")
      end
    end
  end
end