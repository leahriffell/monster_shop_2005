require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      visit '/items'
    end

    it "all items or merchant names are links" do
      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to_not have_link(@dog_bone.name)
    end

    it "I can see a list of all of the items "do
      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inactive")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")
    end

    it "can have image links to item show page" do
      within "#item-#{@pull_toy.id}" do
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
        click_link('item-image')
      end
        expect(current_path).to eq("/items/#{@pull_toy.id}")
    end

    describe "When I visit the items index page to see item stats" do
      before(:each) do
        @paper = @meg.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
        @pencil = @meg.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        @candy = @meg.items.create(name: "Yellow candy", description: "You can eat it!", price: 3, image: "https://images-na.ssl-images-amazon.com/images/I/610ZOacuGPL._SL1050_.jpg", inventory: 100)
        @okay_paper = @meg.items.create(name: "Okay Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
        @okay_pencil = @meg.items.create(name: "Okay Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        @okay_candy = @meg.items.create(name: "Okay candy", description: "You can eat it!", price: 3, image: "https://images-na.ssl-images-amazon.com/images/I/610ZOacuGPL._SL1050_.jpg", inventory: 100)
        @bad_paper = @meg.items.create(name: "Bad Paper", description: "Bad for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
        @bad_pencil = @meg.items.create(name: "Bad Pencil", description: "You cannot write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        @bad_candy = @meg.items.create(name: "Bad candy", description: "You cannot eat it!", price: 3, image: "https://images-na.ssl-images-amazon.com/images/I/610ZOacuGPL._SL1050_.jpg", inventory: 100)
        @very_bad_paper = @meg.items.create(name: "Very Bad Paper", description: "Horrible for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
        @very_bad_pencil = @meg.items.create(name: "Very Bad Pencil", description: "You get hurt by it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

        11.times do
          visit "/items/#{@pull_toy.id}"
          click_on "Add To Cart"
        end

        10.times do
          visit "/items/#{@paper.id}"
          click_on "Add To Cart"
        end

        9.times do
          visit "/items/#{@tire.id}"
          click_on "Add To Cart"
        end

        8.times do
          visit "/items/#{@pencil.id}"
          click_on "Add To Cart"
        end

        7.times do
          visit "/items/#{@candy.id}"
          click_on "Add To Cart"
        end

        5.times do
          visit "/items/#{@bad_paper.id}"
          click_on "Add To Cart"
        end

        4.times do
          visit "/items/#{@bad_pencil.id}"
          click_on "Add To Cart"
        end

        3.times do
          visit "/items/#{@bad_candy.id}"
          click_on "Add To Cart"
        end

        2.times do
          visit "/items/#{@very_bad_paper.id}"
          click_on "Add To Cart"
        end

        visit "/items/#{@very_bad_pencil.id}"
        click_on "Add To Cart"

        visit "/cart"
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

        visit '/items'
      end

      it "can show 5 most and least popular items and quantity bought" do
        expect(page).to have_content("5 Most Popular Items")
        within "??something to designate 5 most popular items section??" do
          expect(page).to have_link(@pull_toy.name)
          expect(page).to have_content("11")
          expect(page).to have_link(@paper.name)
          expect(page).to have_content("10")
          expect(page).to have_link(@tire.name)
          expect(page).to have_content("9")
          expect(page).to have_link(@pencil.name)
          expect(page).to have_content("8")
          expect(page).to have_link(@candy.name)
          expect(page).to have_content("7")
        end
      end

      it "can show 5 least popular items and quantity bought" do
        expect(page).to have_content("5 Least Popular Items")
        within "??something to designate 5 LEAST popular items section??" do
          expect(page).to have_link(@bad_paper.name)
          expect(page).to have_content("5")
          expect(page).to have_link(@bad_pencil.name)
          expect(page).to have_content("4")
          expect(page).to have_link(@bad_candy.name)
          expect(page).to have_content("3")
          expect(page).to have_link(@very_bad_paper.name)
          expect(page).to have_content("2")
          expect(page).to have_link(@very_bad_pencil.name)
          expect(page).to have_content("1")
        end
      end
    end
  end
end
