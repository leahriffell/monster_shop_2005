require 'rails_helper'

RSpec.describe 'Merchant Items' do
  before :each do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create(name: "Ruffhouse", address: '11 Paw Print Lane', city: 'Denver', state: 'CO', zip: 80202)
    @mikes_employee = User.create!(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1, merchant_id: @bike_shop.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@mikes_employee)

    visit "merchant/items"
  end

  it "can add new items" do
    expect(page).to have_link("Add a New Item")
    click_link("Add a new Item")
    

  end



end

# I see a form where I can add new information about an item, including:
# - the name of the item, which cannot be blank
# - a description for the item, which cannot be blank
# - a thumbnail image URL string, which CAN be left blank
# - a price which must be greater than $0.00
# - my current inventory count of this item which is 0 or greater
#
# When I submit valid information and submit the form
# I am taken back to my items page
# I see a flash message indicating my new item is saved
# I see the new item on the page, and it is enabled and available for sale
# If I left the image field blank, I see a placeholder image for the thumbnail
