class AdminController < ApplicationController
  permit :Admin
  
  def index
    redirect_to :controller => "welcome", :action => "index"
  end
  
  def upload_ctsa_data
    @attachment = Attachment.new
  end
  
  def process_ctsa_upload
    action = "index"
    if request.post?
      @attachment = Attachment.new(params[:attachment])
      
      if @attachment.save
        # process the attachment file
        ctsa_schema_reader = CtsaSchemaReader.new(@attachment.data.path)
        ctsa_schema_reader.process

        flash[:notice] = "CTSA data processed successfully"
        action = "view_ctsa_data"
      else
        flash[:warning] = "Could not process CTSA Upload"
        render :action => "upload_ctsa_data"
        return
      end
    
    else
      flash[:warning] = "Could not process CTSA Upload"
    end
    redirect_to :controller => "admin", :action => action
  end
  
  def view_ctsa_data
  end
  
  def activity_codes
    populate_ctsa_data(ActivityCode)
  end
  
  def non_phs_organizations
    populate_ctsa_data(NonPhsOrganization)
  end
  
  def phs_organizations
    populate_ctsa_data(PhsOrganization)
  end
  
  def specialties
    populate_ctsa_data(Specialty)
  end
  
  def countries
    populate_ctsa_data(Country)
  end
  
  def degree_type_ones
    populate_ctsa_data(DegreeTypeOne)
  end
  
  def degree_type_twos
    populate_ctsa_data(DegreeTypeTwo)
  end
  
  def ethnic_types
    populate_ctsa_data(EthnicType)
  end
  
  def race_types
    populate_ctsa_data(RaceType)
  end

  private
  
    def populate_ctsa_data(cls)
      @search = cls.search(params[:search])
      @ctsa_data = @search.paginate(:page => params[:page], :per_page => 20)
    end

end
