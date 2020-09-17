require 'rails_helper'

RSpec.describe 'Merchant Items' do
  before :each do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @mikes_employee = User.create!(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1, merchant_id: @bike_shop.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@mikes_employee)

    visit "merchant/items"
  end

  it "can add new items" do
    expect(page).to have_link("Add a New Item")
    click_link("Add a New Item")

    fill_in :name, with: "Hammock"
    fill_in :description, with: "Very Hammocky"
    fill_in :image, with: "https://pawleysislandhammocks.com/gallery/12oc-pawleys-island-single-cotton-rope-studio-xx.jpg"
    fill_in :price, with: 70
    fill_in :inventory, with: "91"

    click_button("Create Item")

    new_item = Item.last

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{new_item.name} Added!")
    expect(page).to have_content(new_item.name)
    expect(new_item.active?).to eq(true)
    expect(new_item.merchant_id).to eq(@bike_shop.id)
  end

  it "cannot have any empty field other than image" do

  end

  it "has to have a price higher than $0.00" do

  end

  it "cannot have an inventory less than 0" do

  end

  it "has to have a placeholder thumbnail if no image provided" do

  end

end
