require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    before :each do
      visit "/"
    end

    it "can to 404 error if I try to access any path with /merchant" do
      visit merchant_dashboard_path
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    it "can redirect to 404 error if I try to access any path with /admin" do
      visit admin_dashboard_path
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    it "can redirect to 404 error if I try and access profile" do
      visit "/profile"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end