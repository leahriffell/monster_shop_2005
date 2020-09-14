require 'rails_helper'

RSpec.describe 'Cart creation' do
  describe 'When I visit an items show page' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @quantity_test_object_visitor = @mike.items.create(name: "item_visitor", description: "I am a description", price: 10, image: "https://previews.123rf.com/images/albertzig/albertzig1210/albertzig121001618/16005008-3d-cartoon-cute-monster.jpg", inventory: 2)
      @quantity_test_object_regular = @mike.items.create(name: "item_regular", description: "I am a description", price: 10, image: "https://previews.123rf.com/images/albertzig/albertzig1210/albertzig121000361/15625219-3d-cartoon-cute-monster.jpg", inventory: 3)
      @quantity_test_object_merchant = @mike.items.create(name: "item_merchant", description: "I am a description", price: 10, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSSEiGA-5ciHpGWaYBQ-lD25g0mbpYDnhi8xw&usqp=CAU", inventory: 4)
      @quantity_test_object_admin = @mike.items.create(name: "item_admin", description: "I am a description", price: 10, image: "https://static.turbosquid.com/Preview/001299/713/NK/_D.jpg", inventory: 100)

      @cart_visitor = [@quantity_test_object_visitor]
      @cart_regular = [@quantity_test_object_regular]
      @cart_merchant = [@quantity_test_object_merchant]
      @cart_admin = [@quantity_test_object_admin]
    end

    describe "As a visitor" do
      it "I see a link to add this item to my cart" do
        visit "/items/#{@paper.id}"
        expect(page).to have_button("Add To Cart")
      end

      it "I can add this item to my cart" do
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"

        expect(page).to have_content("#{@paper.name} was successfully added to your cart")
        expect(current_path).to eq("/items")

        within '.topnav' do
          expect(page).to have_content("Cart: 1")
        end

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        within 'nav' do
          expect(page).to have_content("Cart: 2")
        end
      end

      it "can update order quantities in cart" do
        visit "/items/#{@quantity_test_object_visitor.id}"
        click_on "Add To Cart"

        within '.topnav' do
          expect(page).to have_content("Cart: 1")
          click_link "Cart: 1"
        end

        @cart_visitor.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_button("plus")
            click_button "plus"
          end
        end

        expect(page).to have_content("You have updated a quantity in your cart")

        click_button("plus")
        expect(page).to have_content("There are limited supplies in inventory - this item has reached it's max! Please try again later.")
      end
    end

    describe "As a Regular User" do
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

      it "can update order quantities in regular user's cart" do
        visit "/items/#{@quantity_test_object_regular.id}"
        click_on "Add To Cart"

        within '.topnav' do
          expect(page).to have_content("Cart: 1")
          click_link "Cart: 1"
        end

        @cart_regular.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_button("plus")
            click_button "plus"
          end
        end

        expect(page).to have_content("You have updated a quantity in your cart")

        click_button("plus")
        expect(page).to have_content("You have updated a quantity in your cart")

        click_button("plus")
        expect(page).to have_content("There are limited supplies in inventory - this item has reached it's max! Please try again later.")
      end
    end

    describe "As a Merchant User" do
      before :each do
        @merchant = User.create(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1)

        visit "/"

        within 'nav' do
          click_link "Login"
        end

        fill_in :email, with: @merchant.email
        fill_in  :password, with: @merchant.password
        click_button "Login"
      end

      it "can update order quantities in merchant user's cart" do
        visit "/items/#{@quantity_test_object_merchant.id}"
        click_on "Add To Cart"

        within '.topnav' do
          expect(page).to have_content("Cart: 1")
          click_link "Cart: 1"
        end

        @cart_merchant.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_button("plus")
            click_button "plus"
          end
        end

        expect(page).to have_content("You have updated a quantity in your cart")

        click_button("plus")
        expect(page).to have_content("You have updated a quantity in your cart")

        click_button("plus")
        expect(page).to have_content("You have updated a quantity in your cart")

        click_button("plus")
        expect(page).to have_content("There are limited supplies in inventory - this item has reached it's max! Please try again later.")
      end
    end

    describe "As an Admin User" do
      before :each do
        @admin = User.create(name:"Priya", address:"13 Elm Street", city:"Denver", state:"CO", zip:"66666", email: "priyavcooltoo@gmail.com", password:"yuuuuuup", password_confirmation:"yuuuuuup", role: 2)

        visit "/"

        within 'nav' do
          click_link "Login"
        end

        fill_in :email, with: @admin.email
        fill_in  :password, with: @admin.password
        click_button "Login"
      end

      it "can NOT see the cart as an admin" do
        visit "/items/#{@quantity_test_object_admin.id}"
        expect(page).to_not have_button("Add To Cart")
      end
    end
  end
end
