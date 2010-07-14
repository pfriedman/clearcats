# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private
  
    def ensure_admin
      if current_user_is_admin 
        # NOOP - render requested page
      else
        flash[:warning] = "You do not have access to the page you requested."
        redirect_to :controller => "welcome", :action => "index"
      end
    end
  
    def current_user_is_admin
      # TODO: determine if the current user is an administrator
      current_user and current_user.username == "admin"
    end
end
