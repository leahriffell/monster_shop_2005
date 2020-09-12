
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    before :each do
      @user = User.create(name:"Jackie Chan", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

      visit '/merchants'

      within 'nav' do
        click_link "Login"
      end

      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"
    end

    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end

    # =========================================================
    # US7
    it "can redirect a user to 404 error if they try to access any path with /merchant" do
      visit "/merchants"
      # UH OH.... This might be a paired decision - I think that even the landing page /merchants should be avoided by a typical user?
      # This means that we need to go check all specs, and any visit to "/merchants" needs to be checked it required update to "/"
      # Then I can find the logic for a before and render when visiting any namespace :merchants
    end

    it "can redirect a user to 404 error if they try to access any path with /admin" do

    end
    # =========================================================
  end
end
