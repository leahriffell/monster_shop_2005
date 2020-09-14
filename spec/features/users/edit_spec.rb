require 'rails_helper'

RSpec.describe "edit user profile data", type: :feature do
  describe "As a logged-in user" do
    before :each do
      @user_1 = User.create(name:"Luke Hunter James-Erickson", address:"123 Lane", city:"Denver", state:"CO", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)
      @user_2 = User.create(name:"Patrick Schwayze", address:"444 Street", city:"Denver", state:"CO", zip:"40404", email: "dirtydancing@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)
 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end
    
    it "can see form pre-populated with current info except for password" do 
      visit profile_edit_path

      expect(find_field(:name).value).to eq(@user_1.name)
      expect(find_field(:address).value).to eq(@user_1.address)
      expect(find_field(:city).value).to eq(@user_1.city)
      expect(find_field(:state).value).to eq(@user_1.state)
      expect(find_field(:zip).value).to eq(@user_1.zip)
      expect(find_field(:email).value).to eq(@user_1.email)
      expect(page).to_not have_content("Password")
      expect(page).to_not have_content(@user_1.password)
    end

    it "can change information" do 
      visit profile_edit_path

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

    it "can require a unique email address" do 
      visit profile_edit_path

      fill_in(:email, with: @user_2.email)
      click_button "Update"

      expect(current_path).to eq(profile_edit_path)
      expect(page).to have_content("Email has already been taken")
    end

    it "can change password" do 
      visit profile_path
      click_link "Change Password"

      expect(find_field(:password).value).to eq("New Password")
      expect(find_field(:password_confirmation).value).to eq("New Password Confirmation")

      fill_in(:password, with: "newpassword")
      fill_in(:password_confirmation, with: "newpassword")
      click_button "Change Password"

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Your password has been updated.")
    end

    it "cannot change password if passwords do not match" do 
      visit profile_path
      click_link "Change Password"

      fill_in(:password, with: "newpassword")
      fill_in(:password_confirmation, with: "doesnotmatch")
      click_button "Change Password"

      expect(current_path).to eq("/profile/edit")
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end