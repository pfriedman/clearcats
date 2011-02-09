# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Bcsec::Rails::SecuredController

  # Exception Notifier
  include ExceptionNotifiable
  ExceptionNotifier.exception_recipients = %w(clearcats-tech-support@northwestern.edu)
  ExceptionNotifier.sender_address = %("ClearCATS Application Error" <clearcats@northwestern.edu>)
  ExceptionNotifier.email_prefix = "[ClearCATS-#{Rails.env}]"
  
  helper_method :current_ctsa_reporting_year, :get_current_user, :faculty_member?
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # Only save the current_user [Bcsec::User] username for auditing
  def user_for_paper_trail
    current_user ? current_user.username : 'n/a'
  end
    
  def current_ctsa_reporting_year
    SYSTEM_CONFIG["current_ctsa_reporting_year"].to_i
  end
  
  protected

    def local_request?
      false
    end

    exception_data :additional_data

    def additional_data
      current_user ? { :current_user => current_user.username } : {}
    end
  
  private
    
    def find_or_create_user
      usr = User.find_or_create_by_netid(current_user.username)
      usr
    end

    def revertit(cls)
      obj     = cls.find(params[:id])
      version = obj.versions.find(params[:version_id])
      obj     = version.reify
      obj.save!
      flash[:notice] = "#{cls} was successfully reverted."
      redirect_to :controller => "#{cls.to_s.tableize}", :action => "versions", :id => obj
    end
    
    def permit_user
      if !current_user.permit?(:Admin, :User)
        flash[:warning] = "You do not have access to the resource you requested."
        redirect_to :controller => "welcome", :action => "index"
      end
    end
    
    def permit_admin
      if !current_user.permit?(:Admin)
        flash[:warning] = "You do not have access to the resource you requested."
        redirect_to :controller => "welcome", :action => "index"
      end
    end
    
    def determine_person(param_key = :id)
      if current_user.permit?(:Admin, :User) or param_key == :id
        @person = Person.find(params[param_key])
      else        
        @person = find_person_by_current_user
      end
      update_person_data(@person)
    end

    def determine_org_units_for_user
      ids = current_user.group_memberships.collect(&:affiliate_ids).flatten.map(&:to_i)
      ids.blank? ? OrganizationalUnit.all : OrganizationalUnit.find_by_cc_pers_affiliate_ids(ids)
    end
    alias :determine_organizational_units_for_user :determine_org_units_for_user

    def get_current_user
      person = find_person_by_current_user
      return person.nil? ? current_user : person
    end
    
    def find_person_by_current_user
      person = Person.find_by_netid(current_user.username)
    end

    def update_person_data(person)
      if person and person.imported
        if person.netid
          FacultyWebService.locate_one(:netid => person.netid)
        elsif person.employeeid
          FacultyWebService.locate_one(:employeeid => person.employeeid)
        end
      end
    end
    
    def faculty_member?
      if [:Admin, :User].any? { |group| current_user.permit?(group) }
        false
      else
        true
      end
    end
    
    def purge_search_params
      params[:search].keys.each do |k| 
        if params[:search][k].blank?
          params[:search].delete(k)
        elsif /\d/ =~ params[:search][k]
          params[:search].delete(k) unless params[:search][k].to_i > 0
        end
      end      
    end

end
