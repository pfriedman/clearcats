class WelcomeController < ApplicationController
  helper :all 
  
  def index
    if current_user
      populate_person
      redirect_to :controller => "welcome", :action => "client_index" if faculty_member?
    end
  end
  
  def client_index
    populate_person if current_user
  end
  
  def upload_error_log
    @lines = Array.new
    file_path = Person.import_error_log(current_user.username)
    File.open(file_path).each_line { |line| @lines << "#{line}"} if File.exists?(file_path)
  end
  
  def faq
  end
  
  def user_guide
    send_file("#{Rails.root}/doc/user_guide.pdf", :type => 'application/pdf')
  end
  
  def add_investigator
    @organizational_unit_id = params[:organizational_unit_id]
  end
  
  private
    
    def populate_person
      @person = Person.find_by_netid(current_user.username)
      @person = FacultyWebService.locate_one({:netid => current_user.username}) if @person.nil?
    end
  
end