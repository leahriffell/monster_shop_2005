require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'instance methods' do
    it 'subtotal' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      expect(item_order_1.subtotal).to eq(200)
    end
  end

  describe 'class methods' do 
    before :each do 
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @item_1 = @meg.items.create!(name: "Bike pump", description: "XYZ", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 30)
      @item_2 = @meg.items.create!(name: "Tready tire", description: "XYZ", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
      @item_3 = @meg.items.create!(name: "Shoe clips", description: "XYZ", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
      @item_4 = @meg.items.create!(name: "Bottle cage", description: "XYZ", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 30)
      @item_5 = @meg.items.create!(name: "Handlebar tape", description: "XYZ", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
      @item_6 = @brian.items.create!(name: "Dog treats", description: "XYZ", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 40)
      @item_7 = @brian.items.create!(name: "Frisbee", description: "XYZ", price: 15, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
      @item_8 = @brian.items.create!(name: "Collar", description: "XYZ", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 30)
      @item_9 = @brian.items.create!(name: "Leash", description: "XYZ", price: 25, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
      @item_10 = @brian.items.create!(name: "Bone", description: "XYZ", price: 6, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 55)

      @order_1 = Order.create!(name: "Tommy boy", address: "1234 Street", city: "Metropolis", state: "CO", zip: 12345)
      @order_2 = Order.create!(name: "Susie", address: "12 Sunshine Road", city: "LA", state: "CA", zip: 55555)
      @order_3 = Order.create!(name: "Larry David", address: "555 Palm Dr", city: "LA", state: "CA", zip: 55555)

      @item_order_1 = ItemOrder.create!(order: @order_1, item: @item_1, price: @item_1.price, quantity: 10)
      @item_order_2 = ItemOrder.create!(order: @order_1, item: @item_2, price: @item_2.price, quantity: 20)
      @item_order_3 = ItemOrder.create!(order: @order_2, item: @item_3, price: @item_3.price, quantity: 30)
      @item_order_4 = ItemOrder.create!(order: @order_2, item: @item_4, price: @item_4.price, quantity: 40)
      @item_order_5 = ItemOrder.create!(order: @order_1, item: @item_5, price: @item_5.price, quantity: 50)
      @item_order_6 = ItemOrder.create!(order: @order_3, item: @item_6, price: @item_6.price, quantity: 60)
      @item_order_7 = ItemOrder.create!(order: @order_2, item: @item_7, price: @item_7.price, quantity: 70)
      @item_order_8 = ItemOrder.create!(order: @order_3, item: @item_8, price: @item_8.price, quantity: 80)
      @item_order_9 = ItemOrder.create!(order: @order_2, item: @item_9, price: @item_9.price, quantity: 90)
      @item_order_10 = ItemOrder.create!(order: @order_3, item: @item_10, price: @item_10.price, quantity: 100)
    end

    describe '.most_popular_items' do
      it 'can return the five most popular items by quantity purchased' do 
        expect(ItemOrder.most_popular_items).to eq([@item_10.id, @item_9.id, @item_8.id, @item_7.id, @item_6.id])
      end
    end
  end
end
