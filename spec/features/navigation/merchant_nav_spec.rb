require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Merchant' do
    before :each do
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @merchant = User.create!(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1, merchant_id: @mike.id)

      visit "/"

      within 'nav' do
        click_link "Login"
      end

      fill_in :email, with: @merchant.email
      fill_in  :password, with: @merchant.password
      click_button "Login"
    end

    it "I see the same links as a regular user with some additional links" do
      within 'nav' do
        expect(page).to have_content("Logged in as #{@merchant.name}")
        expect(page).to have_link("Profile")
        expect(page).to have_link("Logout")
        expect(page).to have_link("Merchant Dashboard")
        expect(page).to have_link("My Items")
        expect(page).to have_content("Cart")
      end
    end

    it "can redirect to 404 error if I try to access any path with /admin" do
      visit admin_dashboard_path
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    it 'I can see a profile link if logged in on all pages' do
      within 'nav' do
        expect(page).to have_link("Profile")
      end
    end

    it 'I can see a logout link if logged in on all pages' do
      within 'nav' do
        expect(page).to have_link("Logout")
      end
    end

    it 'I cannot see a login or register link if logged in on all pages' do
      within 'nav' do
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
      end
    end

    it "I can see 'logged in as' message if logged in on all pages" do
      within 'nav' do
        expect(page).to have_content("Logged in as #{@merchant.name}")
      end
    end
  end
end
