require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Merchant' do
    before :each do
      @merchant = User.create(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1)

      visit "/"

      within 'nav' do
        click_link "Login"
      end
  
      fill_in :email, with: @merchant.email
      fill_in  :password, with: @merchant.password
      click_button "Login"
    end

    it "I see the same links as a regular user and a link to merchant dashboard" do
      within 'nav' do
        expect(page).to have_content("Logged in as #{@merchant.name}")
        expect(page).to have_link("Profile")
        expect(page).to have_link("Logout")
        expect(page).to have_link("Merchant Dashboard")
        expect(page).to have_content("Cart")
      end
    end

    it "can redirect to 404 error if I try to access any path with /admin" do
      visit "/admin"

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end