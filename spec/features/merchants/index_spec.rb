require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  before :each do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    @pawn_shop = Merchant.create!(name: "EZPAWN", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203, active?: false)
    
    @bike_shop_employee = User.create(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1)
    
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@bike_shop_employee)
  end
  
  describe 'as any logged in user' do
    it 'I can see a list of merchants in the system' do
      visit '/merchants'

      expect(page).to have_link("#{@bike_shop.name}")
      expect(page).to have_link("#{@pawn_shop.name}")
    end

    it 'I can see a link to create a new merchant' do
      visit '/merchants'

      expect(page).to have_link("New Merchant")

      click_on "New Merchant"

      expect(current_path).to eq("/merchants/new")
    end
  end

  describe 'as an admin' do
    before :each do 
      @admin = User.create(name:"Priya", address:"13 Elm Street", city:"Denver", state:"CO", zip:"66666", email: "priyavcool@gmail.com", password:"yuuuuuup", password_confirmation:"yuuuuuup", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      visit '/admin/merchants'
    end

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