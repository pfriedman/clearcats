Given /^an authenticated admin user/ do
  @current_user = User.find_or_create_by_username("admin")
  steps %Q{
    Given I am on login
    And I fill in "username" with "admin"
    And I fill in "password" with "admin"
    And I press "Log in" 
  }
end

Given /^an authenticated user$/ do
  @current_user = User.find_or_create_by_username("user")
  steps %Q{
    Given I am on login
    And I fill in "username" with "user"
    And I fill in "password" with "user"
    And I press "Log in" 
  }
end
