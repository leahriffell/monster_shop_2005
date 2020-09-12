
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    before :each do
      @user = User.create(name:"Jackie Chan", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)
      @merchant = User.create(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1)
      @admin = User.create(name:"Priya", address:"13 Elm Street", city:"Denver", state:"CO", zip:"66666", email: "priyavcooltoo@gmail.com", password:"yuuuuuup", password_confirmation:"yuuuuuup", role: 2)

      visit '/merchants'

      within 'nav' do
        click_link "Login"
      end
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

    it "can redirect a regular user to 404 error if they try to access any path with /merchant" do
      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      visit "/merchants"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    it "can redirect a regular user to 404 error if they try to access any path with /admin" do
      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      visit "/admin"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    it "can redirect an admin to 404 error if they try to access any path with /merchant" do
      fill_in :email, with: @admin.email
      fill_in  :password, with: @admin.password
      click_button "Login"

      visit "/merchants"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    it "can redirect an admin to 404 error if they try to access any path with /admin" do
      fill_in :email, with: @admin.email
      fill_in  :password, with: @admin.password
      click_button "Login"

      visit "/cart"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    it "I can see a profile link if logged in on all pages" do
      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      within 'nav' do
        expect(page).to have_link("Profile")
      end
    end

    it "I can see a logout link if logged in on all pages" do
      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      within 'nav' do
        expect(page).to have_link("Logout")
      end
    end

    it "I cannot see a login or register link if logged in on all pages" do
      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      within 'nav' do
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
      end
    end

    it "I can see 'logged in as' message if logged in on all pages" do
      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      within 'nav' do
        expect(page).to have_content("Logged in as #{@user.name}")
      end
    end

    it "I can see Admin Dashboard when logged in as an admin" do
      fill_in :email, with: @admin.email
      fill_in  :password, with: @admin.password
      click_button "Login"

      within 'nav' do
        expect(page).to have_content("Admin Dashboard")
      end
    end

    # it "I can see Admin Dashboard when logged in as an merchant" do
      # fill_in :email, with: @merchant.email
      # fill_in  :password, with: @merchant.password
      # click_button "Login"
    #
    #   within 'nav' do
    #     expect(page).to have_content("Merchant Dashboard")
    #     expect(page).to have_content("Cart")
    #   end
    # end

    it "I can see Admin Dashboard when logged in as an admin" do
      fill_in :email, with: @admin.email
      fill_in  :password, with: @admin.password
      click_button "Login"

      within 'nav' do
        expect(page).to have_content("All Users")
      end
    end

    it "I cannot see cart when logged in as an admin" do
      fill_in :email, with: @admin.email
      fill_in  :password, with: @admin.password
      click_button "Login"

      within 'nav' do
        expect(page).to_not have_content("Cart")
      end
    end
  end
end
