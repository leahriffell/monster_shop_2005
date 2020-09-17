require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Merchant' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @dog_shop = Merchant.create(name: "Ruffhouse", address: '11 Paw Print Lane', city: 'Denver', state: 'CO', zip: 80202)
      @mikes_employee = User.create!(name:"Leah", address:"123 Sesame Street", city:"New York", state:"NY", zip:"90210", email: "Leahsocool@gmail.com", password:"Imeanit", password_confirmation:"Imeanit", role: 1, merchant_id: @bike_shop.id)
      @user = User.create!(name:"EdgeTestUS26", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "bloogblaag@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@mikes_employee)

      @item_1 = @bike_shop.items.create!(name: "Bike pump", description: "XYZ", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 30)
      @item_2 = @bike_shop.items.create!(name: "Tready tire", description: "XYZ", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
      @item_3 = @bike_shop.items.create!(name: "Shoe clips", description: "XYZ", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
      @item_4 = @bike_shop.items.create!(name: "Bottle cage", description: "XYZ", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 30)
      @item_5 = @bike_shop.items.create!(name: "Handlebar tape", description: "XYZ", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
      @item_6 = @dog_shop.items.create!(name: "Dog treats", description: "XYZ", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 40)
      @item_7 = @dog_shop.items.create!(name: "Frisbee", description: "XYZ", price: 15, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
      @item_8 = @dog_shop.items.create!(name: "Collar", description: "XYZ", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 30)
      @item_9 = @dog_shop.items.create!(name: "Leash", description: "XYZ", price: 25, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
      @item_10 = @dog_shop.items.create!(name: "Bone", description: "XYZ", price: 6, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 55)
      #inactive item
      @item_11 = @bike_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @item_12 = @bike_shop.items.create(name: "Watch", description: "Track your times", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 5)
      @order_1 = @user.orders.create!(name: "Tommy boy", address: "1234 Street", city: "Metropolis", state: "CO", zip: 12345)
      @order_2 = @user.orders.create!(name: "Susie", address: "12 Sunshine Road", city: "LA", state: "CA", zip: 55555)
      @order_3 = @user.orders.create!(name: "Larry David", address: "555 Palm Dr", city: "LA", state: "CA", zip: 55555)
      @item_order_1 = ItemOrder.create!(order: @order_1, item: @item_1, price: @item_1.price, quantity: 10)
      @item_order_3 = ItemOrder.create!(order: @order_2, item: @item_3, price: @item_3.price, quantity: 30)
      @item_order_6 = ItemOrder.create!(order: @order_3, item: @item_6, price: @item_6.price, quantity: 60)
      @item_order_7 = ItemOrder.create!(order: @order_2, item: @item_7, price: @item_7.price, quantity: 70)
      @item_order_8 = ItemOrder.create!(order: @order_3, item: @item_8, price: @item_8.price, quantity: 80)
      @item_order_9 = ItemOrder.create!(order: @order_2, item: @item_9, price: @item_9.price, quantity: 90)
      @item_order_10 = ItemOrder.create!(order: @order_3, item: @item_10, price: @item_10.price, quantity: 100)
      @item_order_12 = ItemOrder.create!(order: @order_3, item: @item_11, price: @item_10.price, quantity: 600)

      visit "/merchant"
    end

    it "can see the name and full address of the merchant I work for" do
      expect(page).to have_content(@bike_shop.name)
      expect(page).to have_content(@bike_shop.address)
      expect(page).to have_content(@bike_shop.city)
      expect(page).to have_content(@bike_shop.state)
      expect(page).to have_content(@bike_shop.zip)
    end

    it "can see a list of pending orders" do
      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content(@item_order_1.quantity)
      expect(page).to have_content(@item_order_1.quantity * @item_order_1.price)

      save_and_open_page
    end

  end
end
