require 'spec_helper'

describe ContactListsController do
  def mock_contact_list(stubs={})
    @mock_contact_list ||= mock_model(ContactList, stubs)
  end

  context "logged in as administrator" do

    before(:each) do
      login(admin_login)
    end

    describe "GET index" do
      it "should render the index page" do
        get :index
        response.should be_success
      end
  
      it "assigns all contact_lists as @contact_lists" do
        ContactList.should_receive(:find).with(:all).and_return([mock_contact_list])
        get :index
        assigns[:contact_lists].should == [mock_contact_list]
      end
    end
    
    # describe "GET new" do
    #   it "assigns a new contact_list as @contact_list" do
    #     ContactList.stub(:new).and_return(mock_contact_list)
    #     get :new
    #     assigns[:contact_list].should equal(mock_contact_list)
    #   end
    # end
    # 
    # describe "POST create" do
    # 
    #   describe "with valid params" do
    #     it "assigns a newly created contact_list as @contact_list" do
    #       ContactList.stub(:new).with({'these' => 'params'}).and_return(mock_contact_list(:save => true))
    #       post :create, :contact_list => {:these => 'params'}
    #       assigns[:contact_list].should equal(mock_contact_list)
    #     end
    # 
    #     it "redirects to the created contact_list" do
    #       ContactList.stub(:new).and_return(mock_contact_list(:save => true))
    #       post :create, :contact_list => {}
    #       response.should redirect_to(contact_lists_path)
    #     end
    #   end
    # 
    #   describe "with invalid params" do
    #     it "assigns a newly created but unsaved contact_list as @contact_list" do
    #       ContactList.stub(:new).with({'these' => 'params'}).and_return(mock_contact_list(:save => false))
    #       post :create, :contact_list => {:these => 'params'}
    #       assigns[:contact_list].should equal(mock_contact_list)
    #     end
    # 
    #     it "re-renders the 'new' template" do
    #       ContactList.stub(:new).and_return(mock_contact_list(:save => false))
    #       post :create, :contact_list => {}
    #       response.should render_template('new')
    #     end
    #     
    #     it "re-renders the new template if a contact_list already exists with that email address" do
    #       email = "asdf@asdf.asdf"
    #       Factory(:contact_list, :email => email)
    #       post :create, :contact_list => { :email => email }
    #       flash[:link_warning].should_not be_blank
    #       response.should render_template('new')
    #     end
    #     
    #   end
    # 
    # end
    # 
    # describe "GET edit" do
    #   it "assigns the requested contact_list as @contact_list" do
    #     ContactList.stub(:find).with("37").and_return(mock_contact_list)
    #     get :edit, :id => "37"
    #     assigns[:contact_list].should equal(mock_contact_list)
    #   end
    # end
    # 
    # describe "PUT update" do
    # 
    #   describe "with valid params" do
    #     it "updates the requested contact_list" do
    #       ContactList.should_receive(:find).with("37").and_return(mock_contact_list)
    #       mock_contact_list.should_receive(:update_attributes).with({'these' => 'params'})
    #       put :update, :id => "37", :contact_list => {:these => 'params'}
    #     end
    # 
    #     it "assigns the requested contact_list as @contact_list" do
    #       ContactList.stub(:find).and_return(mock_contact_list(:update_attributes => true))
    #       put :update, :id => "1"
    #       assigns[:contact_list].should equal(mock_contact_list)
    #     end
    # 
    #     it "redirects to the contact_list" do
    #       ContactList.stub(:find).and_return(mock_contact_list(:update_attributes => true))
    #       put :update, :id => "1"
    #       response.should redirect_to(contact_lists_url)
    #     end
    #   end
    # 
    #   describe "with invalid params" do
    #     it "updates the requested contact_list" do
    #       ContactList.should_receive(:find).with("37").and_return(mock_contact_list)
    #       mock_contact_list.should_receive(:update_attributes).with({'these' => 'params'})
    #       put :update, :id => "37", :contact_list => {:these => 'params'}
    #     end
    # 
    #     it "assigns the contact_list as @contact_list" do
    #       ContactList.stub(:find).and_return(mock_contact_list(:update_attributes => false))
    #       put :update, :id => "1"
    #       assigns[:contact_list].should equal(mock_contact_list)
    #     end
    # 
    #     it "re-renders the 'edit' template" do
    #       ContactList.stub(:find).and_return(mock_contact_list(:update_attributes => false))
    #       put :update, :id => "1"
    #       response.should render_template('edit')
    #     end
    #   end
    # 
    # end
    # 
    # describe "DELETE destroy" do
    #   it "destroys the requested contact_list" do
    #     ContactList.should_receive(:find).with("37").and_return(mock_contact_list)
    #     mock_contact_list.should_receive(:destroy)
    #     delete :destroy, :id => "37"
    #   end
    # 
    #   it "redirects to the contact_list list" do
    #     ContactList.stub(:find).and_return(mock_contact_list(:destroy => true))
    #     delete :destroy, :id => "1"
    #     response.should redirect_to(contact_lists_url)
    #   end
    # end
    
  end
end