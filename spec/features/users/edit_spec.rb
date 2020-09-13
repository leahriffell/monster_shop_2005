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
      expect(page).to_not have_content(@user.password)
    end
  end


#   As a registered user
# When I visit my profile page
# I see a link to edit my profile data
# When I click on the link to edit my profile data
# I see a form like the registration page
# The form is prepopulated with all my current information except my password
# When I change any or all of that information
# And I submit the form
# Then I am returned to my profile page
# And I see a flash message telling me that my data is updated
# And I see my updated information
end