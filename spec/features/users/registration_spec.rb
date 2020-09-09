require 'rails_helper'

RSpec.describe "User Registration Page", type: :feature do
  describe "As a visitor" do
    it "Can register a user" do

      visit "/merchants"

      within(".topnav") do
        expect(page).to have_link("Register")
        click_link "Register"
      end

      expect(current_path).to eq("/register")
      username = "Tom Brokaw"
      fill_in :name, with: username
        fill_in  :address, with: "131 Hills Ave"
        fill_in  :city, with: "Tomville"
        fill_in  :state, with: "CO"
        fill_in  :zip, with: "82828"
        fill_in  :email, with: "tombroke@gmail.com"
        fill_in  :password, with: "hiohio38298"
        fill_in  :password_confirmation, with: "hiohio38298"

      click_button "Sign-up"

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Welcome, #{username}")
    end
  end
end


# User Story 10, User Registration

# As a visitor
# When I click on the 'register' link in the nav bar
# Then I am on the user registration page ('/register')
# And I see a form where I input the following data:
# - my name
# - my street address
# - my city
# - my state
# - my zip code
# - my email address
# - my preferred password
# - a confirmation field for my password
#
# When I fill in this form completely,
# And with a unique email address not already in the system
# My details are saved in the database
# Then I am logged in as a registered user
# I am taken to my profile page ("/profile")
# I see a flash message indicating that I am now registered and logged in
