
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    before :each do
      @user = User.create(name:"Jackie Chan", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)
      @merchant = User.create(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1)
      @admin = User.create(name:"Priya", address:"13 Elm Street", city:"Denver", state:"CO", zip:"66666", email: "priyavcooltoo@gmail.com", password:"yuuuuuup", password_confirmation:"yuuuuuup", role: 2)

      visit "/"
    end

    describe 'I can link to all pages within nav' do 
      it 'can link to home page' do 
        within 'nav' do
          click_link 'Home'
        end

        expect(current_path).to eq("/")
      end

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

      it 'can link to user registration' do 
        within 'nav' do
          click_link 'Register'
        end

        expect(current_path).to eq("/register")
      end
    end

    describe 'I can see cart indicator on all pages' do 
      it 'sees number of items in cart' do
        within 'nav' do
          expect(page).to have_content("Cart: 0")
        end

        visit '/items'
        
        within 'nav' do
          expect(page).to have_content("Cart: 0")
        end
      end
    end
    
    describe 'I can see specific nav items if logged in' do 
      before :each do 
        within 'nav' do
          click_link "Login"
        end
        
        fill_in :email, with: @user.email
        fill_in  :password, with: @user.password
        click_button "Login"
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

    describe 'I can see specific nav items if logged in as admin' do 
      before :each do 
        within 'nav' do
          click_link "Login"
        end
        
        fill_in :email, with: @admin.email
        fill_in  :password, with: @admin.password
        click_button "Login"
      end

      it "I can see Admin Dashboard when logged in as an admin" do
        within 'nav' do
          expect(page).to have_content("Admin Dashboard")
        end
      end

      it "I can see All Users when logged in as an admin" do
        within 'nav' do
          expect(page).to have_content("All Users")
        end
      end

      it "I cannot see cart when logged in as an admin" do
        within 'nav' do
          expect(page).to_not have_content("Cart")
        end
      end
    end
  end
end
