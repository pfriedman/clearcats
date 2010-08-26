# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Bcsec::Rails::SecuredController
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private
    
    def find_or_create_user
      User.find_or_create_by_username(current_user.username)
    end

    def revertit(cls)
      obj     = cls.find(params[:id])
      version = obj.versions.find(params[:version_id])
      obj     = version.reify
      obj.save!
      flash[:notice] = "#{cls} was successfully reverted."
      redirect_to :controller => "#{cls.to_s.tableize}", :action => "versions", :id => obj
    end

end
