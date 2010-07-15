Given /^a user exists with username "(.*)"$/ do |username|
  @current_user = create_user(username)
end

Given /^an authenticated admin user/ do
  @current_user = do_login("admin", "admin")
end

Given /^an authenticated user$/ do
  @current_user = do_login("user", "user")
end

Given /^the user has not logged in$/ do
  @current_user = nil
end

When /^(?:when )?I enter username "([^\"]*)" and password "([^\"]*)"$/ do |username, password|
  fill_in 'username', :with => username
  fill_in 'password', :with => password
  click_button 'Login'
end

# extracted helper methods

def do_login(username, password)
  user = create_user(username)
  
  visit "/login" 
  fill_in("username", :with => username)
  fill_in("password", :with => password)
  click_button("Log in")
  
  return user
end

def create_user(username)
  user = User.create!(:username => username)
  return user
end