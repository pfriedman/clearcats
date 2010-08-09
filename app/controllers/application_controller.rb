# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private
  
    def current_user_is_admin
      current_user and current_user.permit?(:Admin)
    end
    
    def find_or_create_user
      User.find_or_create_by_username(current_user.username)
    end
    
end
