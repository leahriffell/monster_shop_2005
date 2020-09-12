require 'rails_helper'

RSpec.describe 'Cart creation' do
  describe 'When I visit an items show page' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @quantity_test_object_visitor = @mike.items.create(name: "item_visitor", description: "I am a description", price: 10, image: "https://previews.123rf.com/images/albertzig/albertzig1210/albertzig121001618/16005008-3d-cartoon-cute-monster.jpg", inventory: 2)
      @quantity_test_object_regular = @mike.items.create(name: "item_regular", description: "I am a description", price: 10, image: "https://previews.123rf.com/images/albertzig/albertzig1210/albertzig121000361/15625219-3d-cartoon-cute-monster.jpg", inventory: 3)
      @quantity_test_object_merchant = @mike.items.create(name: "item_merchant", description: "I am a description", price: 10, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSSEiGA-5ciHpGWaYBQ-lD25g0mbpYDnhi8xw&usqp=CAU", inventory: 2)
      @quantity_test_object_admin = @mike.items.create(name: "item_admin", description: "I am a description", price: 10, image: "https://static.turbosquid.com/Preview/001299/713/NK/_D.jpg", inventory: 3)

      @cart_visitor = [@quantity_test_object_visitor]
      # @cart_visitor = [@quantity_test_object_visitor, @quantity_test_object_regular, @quantity_test_object_merchant, @quantity_test_object_admin]
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

        visit "/cart"
        save_and_open_page
        @cart_visitor.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_button("plus")
            click_button "plus"
          end
        end

        # LEFT OFF HERE - there is a pry in cartcontroller - follow logic from here
        expect(page).to have_content("You have updated a quantity in your cart")

        click_button("plus")
        expect(page).to have_content("There are limited supplies in inventory - this item has reached it's max! Please try again later.")
      end
    end

    describe "As a Regular User" do
      # visit items, add item, visit cart, increase count, restrictions: no more than inventory allows(model method?)
    end

    describe "As a Merchant User" do
      # visit items, add item, visit cart, increase count, restrictions: no more than inventory allows(model method?)
    end

    describe "As an Admin User" do
      # Admins show NOT be able to order items
    end
  end
end
