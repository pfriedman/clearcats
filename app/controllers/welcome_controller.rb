class WelcomeController < ApplicationController
  def index
    if current_user
      @person = Person.find_by_netid(current_user.username)
      @person = FacultyWebService.locate_one({:netid => current_user.username}) if @person.nil?
    end
  end
end