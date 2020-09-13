require 'rails_helper'

RSpec.describe "user profile page", type: :feature do
  describe "As a logged-in user" do

    before :each do
      @user = User.create(name:"Luke Hunter James-Erickson", address:"123 Lane", city:"Denver", state:"CO", zip:"88888", email: "tombroke@gmail.com", password:"Iamapassword", password_confirmation:"Iamapassword", role: 0)
 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/profile"
    end

    it "can see my profile data (except for password)" do
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email)
      expect(page).to_not have_content(@user.password)
      expect(page).to_not have_content(@user.password_confirmation)
    end
  end

  it "can link to form for editing profile data" do 
    click_link "Edit Profile"
    expect(page).to eq(profile_edit_path)
  end
end