require 'rails_helper'

RSpec.describe "Login Page", type: :feature do
  describe "As a visitor" do
    before :each do
      @user = User.create(name:"Luke Hunter James-Erickson", address:"skdjfhdskjfh", city:"kajshd", state:"jsdh", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword")

      visit "/merchants"

      within(".topnav") do
        expect(page).to have_link("Login")
        click_link "Login"
      end
    end

    it "can login a regular user" do

      expect(current_path).to eq("/login")

      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password

      click_button "Login"

      expect(current_path).to eq("/profile")

      expect(page).to have_content("Welcome, #{@user.name}. You are logged in.")
    end




    xit "can login a merchant user" do

      expect(current_path).to eq("/login")

      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password

      click_button "Login"

      expect(current_path).to eq("/  Merchant Dashboard ")

      expect(page).to have_content("Welcome, #{@user.name}")
    end

    xit "can login an admin user" do

      expect(current_path).to eq("/login")

      fill_in :email, with: @user.email
      fill_in  :password, with: @user.password

      click_button "Login"

      expect(current_path).to eq("/   Admin Dashboard")

      expect(page).to have_content("Welcome, #{@user.name}")
    end


  #
  #   it "can edge case test for password confirmation not matching password" do
  #     visit "/register"
  #
  #     username = "Tom Brokaw"
  #     fill_in :name, with: username
  #     fill_in  :address, with: "131 Hills Ave"
  #     fill_in  :city, with: "Tomville"
  #     fill_in  :state, with: "CO"
  #     fill_in  :zip, with: "82828"
  #     fill_in  :email, with: "iamemailhearmeroar@gmail.com"
  #     fill_in  :password, with: "hiohio38298"
  #     fill_in  :password_confirmation, with: "fakenews"
  #
  #     click_button "Sign-up"
  #
  #     expect(page).to have_content("Password confirmation doesn't match Password")
  #     expect(find_field(:address).value).to eq("131 Hills Ave")
  #     expect(find_field(:city).value).to eq("Tomville")
  #     expect(find_field(:state).value).to eq("CO")
  #     expect(find_field(:zip).value).to eq("82828")
  #     expect(find_field(:email).value).to eq("iamemailhearmeroar@gmail.com")
  #     expect(find_field(:password).value).to have_no_content("hiohio38298")
  #     expect(find_field(:password).value).to have_no_content("fakenews")
  #   end
  #
  #   it "can show a flash message when user registration is missing details" do
  #     visit "/register"
  #     fill_in  :address, with: "131 Hills Ave"
  #     fill_in  :city, with: "Tomville"
  #     fill_in  :state, with: "CO"
  #     fill_in  :zip, with: "82828"
  #     fill_in  :email, with: "mynameisleah@gmail.com"
  #     fill_in  :password, with: "hiohio38298"
  #     fill_in  :password_confirmation, with: "hiohio38298"
  #
  #     click_button "Sign-up"
  #
  #     expect(find_field(:address).value).to eq("131 Hills Ave")
  #     expect(find_field(:city).value).to eq("Tomville")
  #     expect(find_field(:state).value).to eq("CO")
  #     expect(find_field(:zip).value).to eq("82828")
  #     expect(find_field(:email).value).to eq("mynameisleah@gmail.com")
  #     expect(find_field(:password).value).to have_no_content("hiohio38298")
  #     expect(page).to have_content("Name can't be blank")
  #   end
  #
  #   it "can require a registration email be unique" do
  #     visit "/register"
  #     username = "Tom Brokaw"
  #     test_email = "tombroke@gmail.com"
  #     fill_in :name, with: username
  #     fill_in  :address, with: "131 Hills Ave"
  #     fill_in  :city, with: "Tomville"
  #     fill_in  :state, with: "CO"
  #     fill_in  :zip, with: "82828"
  #     fill_in  :email, with: test_email
  #     fill_in  :password, with: "hiohio38298"
  #     fill_in  :password_confirmation, with: "hiohio38298"
  #
  #     click_button "Sign-up"
  #
  #     expect(find_field(:name).value).to eq(username)
  #     expect(find_field(:address).value).to eq("131 Hills Ave")
  #     expect(find_field(:city).value).to eq("Tomville")
  #     expect(find_field(:state).value).to eq("CO")
  #     expect(find_field(:zip).value).to eq("82828")
  #     expect(find_field(:email).value).to have_no_content(test_email)
  #     expect(find_field(:password).value).to have_no_content("hiohio38298")
  #     expect(page).to have_content("Email has already been taken")
  #   end
  end
end
