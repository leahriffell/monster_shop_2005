
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As any user' do
    before :each do
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
    end

    describe 'As a non-logged-in user, I can login or register' do
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

    describe 'As a non-admin user, I can see cart indicator on all pages' do
      it 'can link to cart' do
        within 'nav' do
          click_link 'Cart'
        end

        expect(current_path).to eq("/cart")
      end

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
  end
end
