require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      @items_in_cart = [@paper,@tire,@pencil]
    end

    it 'Theres a link to checkout' do
      visit "/cart"

      expect(page).to have_link("Checkout")

      click_on "Checkout"

      expect(current_path).to eq("/orders/new")
    end

    it "requires a visitor to login before checking out" do
      visit "/cart"

      expect(page).to have_content("You must Register or Log In before checking out")
      expect(page).to have_link("Register")
      expect(page).to have_link("Log In")
    end

    it "has a Register link which links to registration page" do
      visit "/cart"

      click_on "Register"

      expect(current_path).to eq("/register")
    end

    it "has a Log In link which links to registration page" do
      visit "/cart"

      click_on "Log In"

      expect(current_path).to eq("/login")
    end

    it "does not prompt useres to login before checking out" do
      @user = User.create(name:"Jackie Chan", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

      visit "/"

      within 'nav' do
        click_link "Login"
      end

      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password
      click_button "Login"

      visit "/cart"

      expect(page).to_not have_content("You must Register or Log In before checking out")
      expect(page).to_not have_link("Register")
      expect(page).to_not have_link("Log In")
    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end
end
