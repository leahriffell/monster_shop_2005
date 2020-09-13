require 'rails_helper'

RSpec.describe "edit user profile data", type: :feature do
  describe "As a logged-in user" do
    before :each do
      @user = User.create(name:"Luke Hunter James-Erickson", address:"123 Lane", city:"Denver", state:"CO", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)
 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_edit_path
    end

    it "can see form pre-populated with current info except for password" do 
      expect(find_field(:name).value).to eq(@user.name)
      expect(find_field(:address).value).to eq(@user.address)
      expect(find_field(:city).value).to eq(@user.city)
      expect(find_field(:state).value).to eq(@user.state)
      expect(find_field(:zip).value).to eq(@user.zip)
      expect(find_field(:email).value).to eq(@user.email)
      expect(page).to_not have_content("Password")
      expect(page).to_not have_content(@user.password)
    end

    it "can change information" do 
      fill_in(:name, with: "LHJE")
      fill_in(:address, with: "555 Street")
      fill_in(:city, with: "New York")
      fill_in(:state, with: "NY")
      fill_in(:zip, with: "12345")
      fill_in(:email, with: "zealot@gmail.com")
      click_button "Update"

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Your profile info has been updated.")
      expect(page).to have_content("LHJE")
      expect(page).to have_content("555 Street")
      expect(page).to have_content("New York")
      expect(page).to have_content("NY")
      expect(page).to have_content("12345")
      expect(page).to have_content("zealot@gmail.com")
    end
  end
end