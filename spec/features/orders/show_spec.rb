require 'rails_helper'

RSpec.describe "order show page", type: :feature do
  describe "As a logged-in user with orders" do
    before :each do
      @user = User.create!(name:"Luke Hunter James-Erickson", address:"123 Lane", city:"Denver", state:"CO", zip:"88888", email: "chadrick@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

      @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @order_1 = @user.orders.create!(name: "Tommy boy", address: "1234 Street", city: "Metropolis", state: "CO", zip: 12345)
      @item_order_1 = ItemOrder.create!(order: @order_1, item: @tire, price: @tire.price, quantity: 10)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "can see all info about the order" do
      visit "profile/orders/#{@order_1.id}"

      expect(page).to have_content("Order: #{@order_1.id}")
      expect(page).to have_content("Order date: #{@order_1.created_at}")
      expect(page).to have_content("Last update: #{@order_1.updated_at}")
      expect(page).to have_content("Status: #{@order_1.status_string}")

      within("#item-#{@order_1.id}") do 
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_1.description)
        expect(page).to have_css("img[src*='#{@item_1.image}']")
        expect(page).to have_content(@item_order_1.quantity)
        expect(page).to have_content(@item_1.price)
        expect(page).to have_content(@item_order_1.number_to_currency(item_order.subtotal))
      end

      expect(page).to have_content("Total quantity: #{@order_1.total_quantity}")
      expect(page).to have_content("Total: #{@order_1.grandtotal}")
    end
  end
end