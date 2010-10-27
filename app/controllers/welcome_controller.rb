class WelcomeController < ApplicationController
  def index
    if current_user
      @person = Person.find_by_netid(current_user.username)
      @person = FacultyWebService.locate_one({:netid => current_user.username}) if @person.nil?
    end
  end
  
  def upload_error_log
    @lines = Array.new
    File.open(Person.import_error_log(current_user.username)).each_line { |line| @lines << "#{line}"}
  end
end