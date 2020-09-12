
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

    it "I can see a profile link if logged in on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_link("Profile")
      end
    end

    it "I can see a logout link if logged in on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_link("Logout")
      end
    end

    it "I cannot see a login or register link if logged in on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
      end
    end

    it "I can see 'logged in as' message if logged in on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Logged in as #{@user.name}")
      end
    end
  end
end
