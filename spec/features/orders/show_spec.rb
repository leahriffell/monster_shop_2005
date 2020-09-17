require 'rails_helper'

RSpec.describe "order show page", type: :feature do
  describe "As a logged-in user with orders" do
    before :each do
      @user = User.create!(name:"Luke Hunter James-Erickson", address:"123 Lane", city:"Denver", state:"CO", zip:"88888", email: "chadrick@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

      @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @bike_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = @user.orders.create!(name: "Tommy boy", address: "1234 Street", city: "Metropolis", state: "CO", zip: 12345)
      @item_order_1 = ItemOrder.create!(order: @order_1, item: @tire, price: @tire.price, quantity: 10)
      @item_order_2 = ItemOrder.create!(order: @order_1, item: @pull_toy, price: @pull_toy.price, quantity: 3, fulfilled?: true)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "can see all info about the order" do
      visit "profile/orders/#{@order_1.id}"

      expect(page).to have_content("Order ID: #{@order_1.id}")
      expect(page).to have_content("Order date: #{@order_1.created_at}")
      expect(page).to have_content("Last update: #{@order_1.updated_at}")
      expect(page).to have_content("Status: #{@order_1.status}")

      within("#item-#{@tire.id}") do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content(@tire.price)
        expect(page).to have_content(@item_order_1.quantity)
        expect(page).to have_content("1,000")
      end

      expect(page).to have_content("Total item quantity: #{@order_1.total_quantity}")
      expect(page).to have_content("Total: $1,030.00")
    end

    it "can cancel an order" do
      visit "profile/orders/#{@order_1.id}"

      click_button "Cancel Order"

      @order_1.item_orders.all?{ |item_order| expect(item_order.fulfilled?).to eq(false) }

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Your order has been cancelled")

      visit "/profile/orders"

      within ("#order-#{@order_1.id}") do
        expect(page).to have_content("Status: Cancelled")
      end
    end
  end
end
