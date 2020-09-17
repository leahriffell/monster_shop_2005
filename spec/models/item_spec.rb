require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5, active?: false)
      @bell = @bike_shop.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create!(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create!(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create!(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create!(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create!(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      user = User.create!(name:"User Story 26", address:"dddd", city:"aaaaa", state:"kkkkk", zip:"88888", email: "us26@gmail.com", password:"Password", password_confirmation:"Password", role: 0)

      order = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it "toggle active" do 
      @chain.toggle_active
      expect(@chain.active?).to eq(true)

      @bell.toggle_active
      expect(@bell.active?).to eq(false)
    end
  end

  describe "class methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @dog_shop = Merchant.create(name: "Ruffhouse", address: '11 Paw Print Lane', city: 'Denver', state: 'CO', zip: 80202)
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
      #"other" item (not popular and not un-popular)
      @item_12 = @bike_shop.items.create(name: "Watch", description: "Track your times", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 5)
      @user = User.create!(name:"EdgeTestUS26", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "bloogblaag@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)
      
      @order_1 = @user.orders.create!(name: "Tommy boy", address: "1234 Street", city: "Metropolis", state: "CO", zip: 12345)
      @order_2 = @user.orders.create!(name: "Susie", address: "12 Sunshine Road", city: "LA", state: "CA", zip: 55555)
      @order_3 = @user.orders.create!(name: "Larry David", address: "555 Palm Dr", city: "LA", state: "CA", zip: 55555)

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
    end

    describe ".active_items" do
      it "can return list of only active items" do
        expect(Item.active_items).to eq([@item_1, @item_2, @item_3, @item_4, @item_5, @item_6, @item_7, @item_8, @item_9, @item_10, @item_12])
      end
    end

    describe '.by_popularity' do
      it 'can return the five most popular active items by quantity purchased' do
        expect(Item.by_popularity(sum_qty: :desc)).to eq([@item_1, @item_10, @item_9, @item_8, @item_7])
      end

      it 'can return the five least popular active items by quantity purchased' do
        expect(Item.by_popularity(:sum_qty)).to eq([@item_2, @item_3, @item_4, @item_5, @item_6])
      end
    end
  end
end
