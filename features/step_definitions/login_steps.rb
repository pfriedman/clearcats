Given /^an authenticated admin user/ do
  @current_user = User.find_or_create_by_netid("cc_admin")
  steps %Q{
    Given I am on login
    And I fill in "username" with "cc_admin"
    And I fill in "password" with "cc_admin"
    And I press "Log in" 
  }
end

Given /^an authenticated user$/ do
  @current_user = User.find_or_create_by_netid("cc_user")
  steps %Q{
    Given I am on login
    And I fill in "username" with "cc_user"
    And I fill in "password" with "cc_user"
    And I press "Log in" 
  }
end