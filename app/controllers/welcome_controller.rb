class WelcomeController < ApplicationController
  def index
    if current_user
      @person = Person.find_by_netid(current_user.username)
      @person = FacultyWebService.locate_one({:netid => current_user.username}) if @person.nil?
      
      if @person.is_a?(Client) and !current_user.permit?(:Admin)
        redirect_to edit_person_path(@person)
      end
      
    end
  end
  
  def upload_error_log
    @lines = Array.new
    file_path = Person.import_error_log(current_user.username)
    File.open(file_path).each_line { |line| @lines << "#{line}"} if File.exists?(file_path)
  end
  
  def faq
  end
  
  def add_investigator
    @organizational_unit_id = params[:organizational_unit_id]
  end
  
end