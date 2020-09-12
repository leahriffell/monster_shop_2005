require 'rails_helper'

RSpec.describe 'merchant new page', type: :feature do
  before :each do
    @bike_shop_employee = User.create(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1)

    visit '/'

    within 'nav' do
      click_link "Login"
    end

    fill_in :email, with: @bike_shop_employee.email
    fill_in  :password, with: @bike_shop_employee.password
    click_button "Login"
  end
  describe 'As a user' do
    it 'I can create a new merchant' do
      visit '/merchants/new'

      name = "Sal's Calz(ones)"
      address = '123 Kindalikeapizza Dr.'
      city = "Denver"
      state = "CO"
      zip = 80204

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Merchant"

      new_merchant = Merchant.last

      expect(current_path).to eq('/merchants')
      expect(page).to have_content(name)
      expect(new_merchant.name).to eq(name)
      expect(new_merchant.address).to eq(address)
      expect(new_merchant.city).to eq(city)
      expect(new_merchant.state).to eq(state)
      expect(new_merchant.zip).to eq(zip)
    end
    it 'I cant create a merchant if all fields are not filled in' do
      visit '/merchants/new'

      name = "Sal's Calz(ones)"
      address = ''
      city = "Denver"
      state = ""
      zip = 80204

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Merchant"

      expect(page).to have_content("Address can't be blank and State can't be blank")
      expect(page).to have_button("Create Merchant")
    end

  end
end
