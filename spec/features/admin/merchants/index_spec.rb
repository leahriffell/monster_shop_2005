require 'rails_helper'

RSpec.describe 'Admin Merchants Index Page' do
  before :each do 
    @admin = User.create(name:"Priya", address:"13 Elm Street", city:"Denver", state:"CO", zip:"66666", email: "priyavcool@gmail.com", password:"yuuuuuup", password_confirmation:"yuuuuuup", role: 2)

    @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210, active?: false)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit '/admin/merchants'
  end

  describe "as an admin" do
    it 'can disable an active merchant' do
      within("#merchant-#{@bike_shop.id}") do 
        expect(page).to have_content("Status: Active")
        expect(page).to have_link("Disable")
        click_link "Disable"
      end

      expect(current_path).to eq ('/admin/merchants')
      expect(page).to have_content("#{@bike_shop.name} is now disabled")

      within("#merchant-#{@bike_shop.id}") do 
        expect(page).to have_content("Status: Disabled")
        expect(page).to_not have_button("Disable")
      end
    end
  end
end