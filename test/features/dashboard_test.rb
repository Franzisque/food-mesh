require "test_helper"

class DashboardTest < Capybara::Rails::TestCase
  test "check home page" do
    visit root_path
    assert_content page, "food mesh"
  end

  test "check login" do
      visit '/admin'
      assert_content page, "Login to Foodmesh"

      fill_in('Email', :with => 'demo@fh-salzburg.ac.at')
      fill_in('Password', :with => 'foodmesh#2014')
      click_button('Log in')

      assert_content page, 'Admin Dashboard'
  end
end
