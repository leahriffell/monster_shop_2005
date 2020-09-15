require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @pet_shop = Merchant.create(name: "Ruffhouse", address: '11 Paw Print Lane', city: 'Denver', state: 'CO', zip: 80202)

      @item_1 = @bike_shop.items.create!(name: "Bike pump", description: "XYZ", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 30)
      @item_2 = @bike_shop.items.create!(name: "Tready tire", description: "XYZ", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
      @item_3 = @bike_shop.items.create!(name: "Shoe clips", description: "XYZ", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
      @item_4 = @bike_shop.items.create!(name: "Bottle cage", description: "XYZ", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 30)
      @item_5 = @bike_shop.items.create!(name: "Handlebar tape", description: "XYZ", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
      @item_6 = @pet_shop.items.create!(name: "Dog treats", description: "XYZ", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 40)
      @item_7 = @pet_shop.items.create!(name: "Frisbee", description: "XYZ", price: 15, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
      @item_8 = @pet_shop.items.create!(name: "Collar", description: "XYZ", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 30)
      @item_9 = @pet_shop.items.create!(name: "Leash", description: "XYZ", price: 25, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
      @item_10 = @pet_shop.items.create!(name: "Bone", description: "XYZ", price: 6, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 55)
      #inactive item
      @item_11 = @bike_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://www.sefiles.net/merchant/2166/images/site/tbs-hp-shop-rec-bikes-slimC.jpg?t=1595367301789", active?:false, inventory: 21)
      #"other" item (not popular and not un-popular)
      @item_12 = @bike_shop.items.create(name: "Watch", description: "Track your times", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 5)

      @order_1 = Order.create!(name: "Tommy boy", address: "1234 Street", city: "Metropolis", state: "CO", zip: 12345)
      @order_2 = Order.create!(name: "Susie", address: "12 Sunshine Road", city: "LA", state: "CA", zip: 55555)
      @order_3 = Order.create!(name: "Larry David", address: "555 Palm Dr", city: "LA", state: "CA", zip: 55555)

      @item_order_1 = ItemOrder.create!(order: @order_1, item: @item_1, price: @item_1.price, quantity: 10)
      @item_order_1 = ItemOrder.create!(order: @order_2, item: @item_1, price: @item_1.price, quantity: 500)
      @item_order_2 = ItemOrder.create!(order: @order_1, item: @item_2, price: @item_2.price, quantity: 20)
      @item_order_3 = ItemOrder.create!(order: @order_2, item: @item_3, price: @item_3.price, quantity: 30)
      @item_order_4 = ItemOrder.create!(order: @order_2, item: @item_4, price: @item_4.price, quantity: 40)
      @item_order_5 = ItemOrder.create!(order: @order_1, item: @item_5, price: @item_5.price, quantity: 50)
      @item_order_6 = ItemOrder.create!(order: @order_3, item: @item_6, price: @item_6.price, quantity: 60)
      @item_order_7 = ItemOrder.create!(order: @order_2, item: @item_7, price: @item_7.price, quantity: 70)
      @item_order_8 = ItemOrder.create!(order: @order_3, item: @item_8, price: @item_8.price, quantity: 80)
      @item_order_9 = ItemOrder.create!(order: @order_2, item: @item_9, price: @item_9.price, quantity: 90)
      @item_order_10 = ItemOrder.create!(order: @order_3, item: @item_10, price: @item_10.price, quantity: 100)
      @item_order_11 = ItemOrder.create!(order: @order_3, item: @item_12, price: @item_10.price, quantity: 61)
      # edge case for non-active item having past orders
      @item_order_12 = ItemOrder.create!(order: @order_3, item: @item_11, price: @item_10.price, quantity: 600)

      visit '/items'
    end

    it "all items or merchant names are links" do
      expect(page).to have_link(@item_1.name)
      expect(page).to have_link(@item_1.merchant.name)
      expect(page).to have_link(@item_2.name)
      expect(page).to have_link(@item_2.merchant.name)
      expect(page).to_not have_link(@item_11.name)
    end

    it "I can see a list of all of the items "do
      within "#item-#{@item_1.id}" do
        expect(page).to have_link(@item_1.name)
        expect(page).to have_content(@item_1.description)
        expect(page).to have_content("Price: $#{@item_1.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@item_1.inventory}")
        expect(page).to have_link(@bike_shop.name)
        expect(page).to have_css("img[src*='#{@item_1.image}']")
      end

      within "#item-#{@item_6.id}" do
        expect(page).to have_link(@item_6.name)
        expect(page).to have_content(@item_6.description)
        expect(page).to have_content("Price: $#{@item_6.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@item_6.inventory}")
        expect(page).to have_link(@pet_shop.name)
        expect(page).to have_css("img[src*='#{@item_6.image}']")
      end

      expect(page).to_not have_link(@item_11.name)
      expect(page).to_not have_content(@item_11.description)
      expect(page).to_not have_content("Inactive")
      expect(page).to_not have_content("Inventory: #{@item_11.inventory}")
      expect(page).to_not have_css("img[src*='#{@item_11.image}']")
    end

    it "can have image links to item show page" do
      within "#item-#{@item_1.id}" do
        expect(page).to have_css("img[src*='#{@item_1.image}']")
        click_link('item-image')
      end
        expect(current_path).to eq("/items/#{@item_1.id}")
    end

    it "can see an area with most popular items and their qty purchased" do
      within ".most-popular" do
        expect(page).to have_link(@item_1.name)
        expect(page).to have_content("Amount Purchased: 510")
        expect(page).to have_link(@item_10.name)
        expect(page).to have_content("Amount Purchased: 100")
        expect(page).to have_link(@item_9.name)
        expect(page).to have_content("Amount Purchased: 90")
        expect(page).to have_link(@item_8.name)
        expect(page).to have_content("Amount Purchased: 80")
        expect(page).to have_link(@item_7.name)
        expect(page).to have_content("Amount Purchased: 70")
      end
    end
      
    it "can see a section with least popular items and their qty purchased" do 
      within ".least-popular" do
        expect(page).to have_link(@item_2.name)
        expect(page).to have_content("Amount Purchased: 20")
        expect(page).to have_link(@item_3.name)
        expect(page).to have_content("Amount Purchased: 30")
        expect(page).to have_link(@item_4.name)
        expect(page).to have_content("Amount Purchased: 40")
        expect(page).to have_link(@item_5.name)
        expect(page).to have_content("Amount Purchased: 50")
        expect(page).to have_link(@item_6.name)
        expect(page).to have_content("Amount Purchased: 60")
      end
    end
  end
end
