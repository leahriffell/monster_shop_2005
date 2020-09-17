require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it { should belong_to :user}
    it { should have_many :item_orders}
    it { should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @user = User.create!(name:"User Story 26", address:"dddd", city:"aaaaa", state:"kkkkk", zip:"88888", email: "us26@gmail.com", password:"Password", password_confirmation:"Password", role: 0)
      @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 2)
      @order_2 = @user.orders.create!(name: 'Phil', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 0)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
      @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
      # @tire.update(inventory: 7)
      @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 5, fulfilled?: true)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it "total_quantity" do
      expect(@order_1.total_quantity).to eq(5)
    end

    it "change_to_cancel_status" do 
      @order_2.change_to_cancel_status
      expect(@order_2.status).to eq("Cancelled")
    end

    it "unfulfill_item_orders" do 
      expect(@tire.inventory).to eq(12)
      @order_2.unfulfill_item_orders
      # expect(@tire.inventory).to eq(17)
      @order_2.item_orders.all?{ |item_order| expect(item_order.fulfilled?).to eq(false) }
    end

    it "cancel" do 
      @order_2.cancel 
      expect(@order_2.status).to eq("Cancelled")
      # expect(@tire.inventory).to eq(17)
      @order_2.item_orders.all?{ |item_order| expect(item_order.fulfilled?).to eq(false) }
    end
  end
end
