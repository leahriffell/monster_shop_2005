
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    before :each do
      @user = User.create(name:"Jackie Chan", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

      visit "/"
    end

    describe 'I can link to all pages within nav' do 
      it 'can link to items index' do
        within 'nav' do
          click_link 'All Items'
        end

        expect(current_path).to eq('/items')
      end

      it 'can link to merchants index' do 
        within 'nav' do
          click_link 'All Merchants'
        end

        expect(current_path).to eq('/merchants')
      end

      it 'can link to home page' do 
        within 'nav' do
          click_link 'Home'
        end

        expect(current_path).to eq("/")
      end

      it 'can link to cart' do 
        within 'nav' do
          click_link 'Cart'
        end

        expect(current_path).to eq("/cart")
      end

      it 'can link to login' do 
        within 'nav' do
          click_link 'Login'
        end

        expect(current_path).to eq("/login")
      end
    end

    it "I can see a cart indicator on all pages" do
      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end

    it "I can see a profile link if logged in on all pages" do
      within 'nav' do
        click_link "Login"
      end

      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      within 'nav' do
        expect(page).to have_link("Profile")
      end
    end

    it "I can see a logout link if logged in on all pages" do
      within 'nav' do
        click_link "Login"
      end

      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      within 'nav' do
        expect(page).to have_link("Logout")
      end
    end

    it "I cannot see a login or register link if logged in on all pages" do
      within 'nav' do
        click_link "Login"
      end

      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      within 'nav' do
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
      end
    end

    it "I can see 'logged in as' message if logged in on all pages" do
      within 'nav' do
        click_link "Login"
      end

      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      within 'nav' do
        expect(page).to have_content("Logged in as #{@user.name}")
      end
    end
  end
end
