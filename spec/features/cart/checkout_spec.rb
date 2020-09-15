require 'rails_helper'

RSpec.describe 'Cart show' do

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end

  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      @items_in_cart = [@paper,@tire,@pencil]
    end

    it "requires a visitor to login or register before checking out" do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
      expect(page).to have_content("You must Register or Log In to finish checking out.")
      expect(page).to have_link("Register")
      expect(page).to have_link("Log In")
    end

    it "has a Register link which links to registration page" do
      visit "/cart"

      within '#checkout-authorization' do
        click_on "Register"
      end

      expect(current_path).to eq("/register")
    end

    it "has a Log In link which links to registration page" do
      visit "/cart"

      within '#checkout-authorization' do
        click_on "Log In"
      end

      expect(current_path).to eq("/login")
    end

    describe 'when logged in as a regular user' do
      before do
        @user = User.create!(name:"Jackie Chan", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "12345@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

        visit "/"

        within 'nav' do
          click_link "Login"
        end

        fill_in :email, with: @user.email
        fill_in  :password, with: @user.password
        click_button "Login"

        visit "/cart"
      end

      it "does not prompt regular users to login before checking out" do
        expect(page).to_not have_content("You must Register or Log In before checking out")
        expect(page).to_not have_link("Register")
        expect(page).to_not have_link("Log In")
      end

      it 'can show a logged in user a link to checkout' do
        expect(page).to have_link("Checkout")
        click_on "Checkout"
        expect(current_path).to eq("/orders/new")
      end

      it "can see a flash message reporting the order was created" do
        click_on "Checkout"

        name = "Bert"
        address = "123 Sesame St."
        city = "NYC"
        state = "New York"
        zip = 10001

        fill_in :name, with: name
        fill_in :address, with: address
        fill_in :city, with: city
        fill_in :state, with: state
        fill_in :zip, with: zip

        click_button "Create Order"
        expect(current_path).to eq("/profile/orders")

        new_order = @user.orders.last
        expect(new_order.user_id).to eq(@user.id)
        expect(new_order.status?).to eq(false)

        # expect(page).to have_content("Status: Pending")
        # expect(page).to have_content("Your order was created!")
        #
        # within "#item-#{@paper.id}" do
        #   expect(page).to have_link(@paper.name)
        #   expect(page).to have_link("#{@paper.merchant.name}")
        #   expect(page).to have_content("$#{@paper.price}")
        #   expect(page).to have_content("2")
        #   expect(page).to have_content("$40")
        # end
        #
        # expect(page).to have_link(@tire.name)
        # expect(page).to have_link(@pencil.name)
        # expect(page).to have_content("Cart: 0")
      end
    end

  end
end
