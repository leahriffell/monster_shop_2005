require 'rails_helper'

RSpec.describe "Logout process", type: :feature do
  describe "As a logged-in user I can logout" do

    before :each do
      @user = User.create(name:"Luke Hunter James-Erickson", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)
      @merchant = User.create(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1)
      @admin = User.create(name:"Priya", address:"13 Elm Street", city:"Denver", state:"CO", zip:"66666", email: "priyavcooltoo@gmail.com", password:"yuuuuuup", password_confirmation:"yuuuuuup", role: 2)

      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)

      visit "/items/#{@paper.id}"

      click_on "Add To Cart"

      within(".topnav") do
        expect(page).to have_link("Login")
        click_link "Login"
      end
    end

    it "Can logout a regular logged-in user" do
      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password

      click_button "Login"

      within(".topnav") do
        expect(page).to have_link("Cart: 1")
      end

      within(".topnav") do
        expect(page).to have_link("Logout")
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
        click_link "Logout"
      end

      expect(current_path).to eq("/")
      expect(page).to have_content("Congrats, you're leaving, but you should stay!")
      within(".topnav") do
        expect(page).to have_link("Cart: 0")
        click_link "Login"
      end

      expect(current_path).to eq('/login')
    end

    it "Can logout a merchant logged-in user" do
      fill_in :email, with: @merchant.email
      fill_in  :password, with: @merchant.password

      click_button "Login"

      within(".topnav") do
        expect(page).to have_link("Cart: 1")
      end

      within(".topnav") do
        expect(page).to have_link("Logout")
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
        click_link "Logout"
      end

      expect(current_path).to eq("/")
      expect(page).to have_content("Congrats, you're leaving, but you should stay!")
      within(".topnav") do
        expect(page).to have_link("Cart: 0")
        click_link "Login"
      end

      expect(current_path).to eq('/login')
    end

    it "Can logout a admin logged-in user" do
      fill_in :email, with: @admin.email
      fill_in  :password, with: @admin.password

      click_button "Login"

      within(".topnav") do
        expect(page).to have_link("Logout")
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
        click_link "Logout"
      end

      expect(current_path).to eq("/")
      expect(page).to have_content("Congrats, you're leaving, but you should stay!")
      within(".topnav") do
        expect(page).to have_link("Cart: 0")
        click_link "Login"
      end

      expect(current_path).to eq('/login')
    end
  end
end
