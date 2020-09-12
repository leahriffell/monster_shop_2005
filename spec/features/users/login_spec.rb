require 'rails_helper'

RSpec.describe "Login Page", type: :feature do
  describe "As a visitor" do
    before :each do
      @user = User.create(name:"Luke Hunter James-Erickson", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)
      @merchant = User.create(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1)
      @admin = User.create(name:"Priya", address:"13 Elm Street", city:"Denver", state:"CO", zip:"66666", email: "priyavcooltoo@gmail.com", password:"yuuuuuup", password_confirmation:"yuuuuuup", role: 2)

      visit "/merchants"

      within(".topnav") do
        expect(page).to have_link("Login")
        click_link "Login"
      end
    end

    it "can login a regular user" do
      expect(current_path).to eq("/login")

      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password

      click_button "Login"

      expect(current_path).to eq("/profile")

      expect(page).to have_content("Welcome, #{@user.name}. You are logged in!")
    end

    it "can login a merchant user" do
      expect(current_path).to eq("/login")

      fill_in :email, with: @merchant.email
      fill_in  :password, with: @merchant.password

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      click_button "Login"

      expect(current_path).to eq("/merchants/dashboard")

      expect(page).to have_content("Welcome Merchant, #{@merchant.name}!")
    end

    it "can login an admin user" do
      expect(current_path).to eq("/login")

      fill_in :email, with: @admin.email
      fill_in  :password, with: @admin.password

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      click_button "Login"

      expect(current_path).to eq("/admin/dashboard")

      expect(page).to have_content("Welcome Admin, #{@admin.name}!")
    end

    it "cannot login user with incorrect email" do
      expect(current_path).to eq("/login")

      fill_in :email, with: "incorrect email"
      fill_in  :password, with: @user.password
      click_button "Login"

      expect(current_path).to eq("/login")

      expect(page).to have_content("Incorrect email or password.")
    end

    it "cannot login user with incorrect password" do
      expect(current_path).to eq("/login")

      fill_in :email, with: @user.email
      fill_in  :password, with: "incorrect password"
      click_button "Login"

      expect(current_path).to eq("/login")

      expect(page).to have_content("Incorrect email or password.")
    end

    it "cannot login user with incorrect email and incorrect password" do
      expect(current_path).to eq("/login")

      fill_in :email, with: "incorrect email"
      fill_in  :password, with: "incorrect password"
      click_button "Login"

      expect(current_path).to eq("/login")

      expect(page).to have_content("Incorrect email or password.")
    end

    it "can redirect a logged in regular user to profile" do
      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      visit "/merchants"
      visit "/login"
      expect(current_path).to eq("/profile")
    end

    it "can redirect a logged in merchant user to dashboard" do
      fill_in :email, with: @merchant.email
      fill_in  :password, with: @merchant.password
      click_button "Login"

      visit "/merchants"
      visit "/login"
      expect(current_path).to eq("/merchants/dashboard")
    end

    it "can redirect a logged in admin user to dashboard" do
      fill_in :email, with: @admin.email
      fill_in  :password, with: @admin.password
      click_button "Login"

      visit "/merchants"
      visit "/login"
      expect(current_path).to eq("/admin/dashboard")
    end

    it "cannot redirect a logged in regular user to a dashboard" do
      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      visit "/merchants"
 
      visit "/login"
      expect(current_path).to_not eq("/merchants/dashboard")
      expect(current_path).to_not eq("/admin/dashboard")
    end
  end
end
