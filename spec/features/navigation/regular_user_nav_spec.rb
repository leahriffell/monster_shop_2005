
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Regular user' do
    before :each do
      @user = User.create(name:"Jackie Chan", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

      visit "/"

      within 'nav' do
        click_link "Login"
      end

      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"
    end

    it "can redirect a regular user to 404 error if they try to access any path with /merchant" do
      visit merchants_dashboard_path
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    it "can redirect a regular user to 404 error if they try to access any path with /admin" do
      visit "/admin"
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
        expect(page).to have_content("Logged in as #{@user.name}")
      end
    end
  end
end