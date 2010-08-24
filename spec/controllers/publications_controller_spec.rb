require 'spec_helper'

describe PublicationsController do

  def mock_publication(stubs={})
    @mock_publication ||= mock_model(Publication, stubs)
  end
  
  context "with an authenticated user" do
    before(:each) do
      login(user_login)
    end

    describe "GET index" do
      
      it "should redirect to the people index page if no person identified" do
        get :index
        response.should redirect_to people_path
      end
      
      it "assigns all publications for the requested person as @publications" do
        person = mock_model(Person, :netid => "wakibbe")
        Publication.should_receive(:search).with("person_id" => person.id.to_s, "order" => "ascend_by_publication_date").and_return([mock_publication])
        LatticeGridWebService.stub!(:make_request).and_return(publications_response)
        Person.should_receive(:find).with(person.id.to_s).and_return(person)
        get :index, :person_id => person.id
        assigns[:publications].should_not be_empty
      end
      
    end

    describe "GET edit" do
      it "assigns the requested publication as @publication" do
        Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
        Publication.stub(:find).with("37").and_return(mock_publication)
        get :edit, :id => "37", :service_id => "99"
        assigns[:publication].should equal(mock_publication)
      end
    end

    describe "PUT update" do
    
      describe "with valid params" do
        it "updates the requested publication" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Publication.should_receive(:find).with("37").and_return(mock_publication)
          mock_publication.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :publication => {:these => 'params'}, :service_id => "99"
        end
      end

      describe "with invalid params" do
        it "updates the requested publication" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Publication.should_receive(:find).with("37").and_return(mock_publication)
          mock_publication.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :publication => {:these => 'params'}, :service_id => "99"
        end
    
        it "assigns the publication as @publication" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Publication.stub(:find).and_return(mock_publication(:update_attributes => false))
          put :update, :id => "1", :service_id => "99"
          assigns[:publication].should equal(mock_publication)
        end
    
        it "re-renders the 'edit' template" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Publication.stub(:find).and_return(mock_publication(:update_attributes => false))
          put :update, :id => "1", :service_id => "99"
          response.should render_template('edit')
        end
      end
    
    end

  end
end

def publications_response
body = %q([{"abstract":{"updated_id":null,"journal_abbreviation":"BMC Res Notes","is_last_author_investigator":false,"deposited_date":"2010-01-19","deleted_id":null,"created_at":"2010-07-23T21:53:56Z","updated_ip":null,"title":"A collection of bioconductor methods to visualize gene-list annotations.","mesh":"","isbn":null,"deleted_ip":null,"citation_last_get_at":null,"updated_at":"2010-07-23T21:53:56Z","publication_date":"2010-01-01","journal":"BMC research notes","is_first_author_investigator":false,"deleted_at":null,"citation_url":null,"url":"","publication_type":"Journal Article","full_authors":"Feng, Gang\nDu, Pan\nKrett, Nancy L\nTessel, Michael\nRosen, Steven\nKibbe, Warren A\nLin, Simon M","abstract":"ABSTRACT: BACKGROUND: Gene-list annotations are critical for researchers to explore the complex relationships between genes and functionalities. Currently, the annotations of a gene list are usually summarized by a table or a barplot. As such, potentially biologically important complexities such as one gene belonging to multiple annotation categories are difficult to extract. We have devised explicit and efficient visualization methods that provide intuitive methods for interrogating the intrinsic connections between biological categories and genes. FINDINGS: We have constructed a data model and now present two novel methods in a Bioconductor package, \"GeneAnswers\", to simultaneously visualize genes, concepts (a.k.a. annotation categories), and concept-gene connections (a.k.a. annotations): the \"Concept-and-Gene Network\" and the \"Concept-and-Gene Cross Tabulation\". These methods have been tested and validated with microarray-derived gene lists. CONCLUSIONS: These new visualization methods can effectively present annotations using Gene Ontology, Disease Ontology, or any other user-defined gene annotations that have been pre-associated with an organism's genome by human curation, automated pipelines, or a combination of the two. The gene-annotation data model and associated methods are available in the Bioconductor package called \"GeneAnswers \" described in this publication.","publication_status":"epublish","id":122,"endnote_citation":"%0 Journal Article\n%A Feng, G.\n%A Du, P.\n%A Krett, N. L.\n%A Tessel, M.\n%A Rosen, S.\n%A Kibbe, W. A.\n%A Lin, S. M.\n%D 2010\n%T A collection of bioconductor methods to visualize gene-list annotations.\n%J BMC Res Notes\n%V 3\n%P 10\n%M 20180973\n%U http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=PubMed&dopt=Citation&list_uids=20180973\n%X ABSTRACT: BACKGROUND: Gene-list annotations are critical for researchers to explore the complex relationships between genes and functionalities. Currently, the annotations of a gene list are usually summarized by a table or a barplot. As such, potentially biologically important complexities such as one gene belonging to multiple annotation categories are difficult to extract. We have devised explicit and efficient visualization methods that provide intuitive methods for interrogating the intrinsic connections between biological categories and genes. FINDINGS: We have constructed a data model and now present two novel methods in a Bioconductor package, \"GeneAnswers\", to simultaneously visualize genes, concepts (a.k.a. annotation categories), and concept-gene connections (a.k.a. annotations): the \"Concept-and-Gene Network\" and the \"Concept-and-Gene Cross Tabulation\". These methods have been tested and validated with microarray-derived gene lists. CONCLUSIONS: These new visualization methods can effectively present annotations using Gene Ontology, Disease Ontology, or any other user-defined gene annotations that have been pre-associated with an organism's genome by human curation, automated pipelines, or a combination of the two. The gene-annotation data model and associated methods are available in the Bioconductor package called \"GeneAnswers \" described in this publication.\n%+ Northwestern University Biomedical Informatics Center (NUBIC, part of the Northwestern CTSA) and The Robert H, Lurie Comprehensive Cancer Center, Northwestern University, Chicago, IL 60611, USA. s-lin2@northwestern.edu.","volume":"3","pages":"10","year":"2010","issue":"","issn":null,"pubmed":"20180973","electronic_publication_date":"2010-02-26","citation_cnt":0,"authors":"Feng, G.\nDu, P.\nKrett, N. L.\nTessel, M.\nRosen, S.\nKibbe, W. A.\nLin, S. M.","status":"In-Data-Review","created_id":null,"created_ip":null}},{"abstract":{"updated_id":null,"journal_abbreviation":"Bioinformatics","is_last_author_investigator":false,"deposited_date":null,"deleted_id":null,"created_at":"2010-07-23T21:55:29Z","updated_ip":null,"title":"From disease ontology to disease-ontology lite: statistical methods to adapt a general-purpose ontology for the test of gene-ontology associations.","mesh":"Computational Biology/*methods;\nData Interpretation, Statistical;\nDatabase Management Systems;\nDatabases, Genetic/classification;\nDisease/*genetics;\nGenome;\nTerminology as Topic;\n*Vocabulary, Controlled","isbn":null,"deleted_ip":null,"citation_last_get_at":null,"updated_at":"2010-07-23T21:55:29Z","publication_date":"2009-06-15","journal":"Bioinformatics (Oxford, England)","is_first_author_investigator":false,"deleted_at":null,"citation_url":null,"url":"","publication_type":"Journal Article","full_authors":"Du, Pan\nFeng, Gang\nFlatow, Jared\nSong, Jie\nHolko, Michelle\nKibbe, Warren A\nLin, Simon M","abstract":"Subjective methods have been reported to adapt a general-purpose ontology for a specific application. For example, Gene Ontology (GO) Slim was created from GO to generate a highly aggregated report of the human-genome annotation. We propose statistical methods to adapt the general purpose, OBO Foundry Disease Ontology (DO) for the identification of gene-disease associations. Thus, we need a simplified definition of disease categories derived from implicated genes. On the basis of the assumption that the DO terms having similar associated genes are closely related, we group the DO terms based on the similarity of gene-to-DO mapping profiles. Two types of binary distance metrics are defined to measure the overall and subset similarity between DO terms. A compactness-scalable fuzzy clustering method is then applied to group similar DO terms. To reduce false clustering, the semantic similarities between DO terms are also used to constrain clustering results. As such, the DO terms are aggregated and the redundant DO terms are largely removed. Using these methods, we constructed a simplified vocabulary list from the DO called Disease Ontology Lite (DOLite). We demonstrated that DOLite results in more interpretable results than DO for gene-disease association tests. The resultant DOLite has been used in the Functional Disease Ontology (FunDO) Web application at http://www.projects.bioinformatics.northwestern.edu/fundo.","publication_status":"ppublish","id":125,"endnote_citation":"%0 Journal Article\n%A Du, P.\n%A Feng, G.\n%A Flatow, J.\n%A Song, J.\n%A Holko, M.\n%A Kibbe, W. A.\n%A Lin, S. M.\n%D 2009\n%T From disease ontology to disease-ontology lite: statistical methods to adapt a general-purpose ontology for the test of gene-ontology associations.\n%J Bioinformatics\n%V 25\n%N 12\n%P i63-i68\n%M 19478018\n%U http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=PubMed&dopt=Citation&list_uids=19478018\n%X Subjective methods have been reported to adapt a general-purpose ontology for a specific application. For example, Gene Ontology (GO) Slim was created from GO to generate a highly aggregated report of the human-genome annotation. We propose statistical methods to adapt the general purpose, OBO Foundry Disease Ontology (DO) for the identification of gene-disease associations. Thus, we need a simplified definition of disease categories derived from implicated genes. On the basis of the assumption that the DO terms having similar associated genes are closely related, we group the DO terms based on the similarity of gene-to-DO mapping profiles. Two types of binary distance metrics are defined to measure the overall and subset similarity between DO terms. A compactness-scalable fuzzy clustering method is then applied to group similar DO terms. To reduce false clustering, the semantic similarities between DO terms are also used to constrain clustering results. As such, the DO terms are aggregated and the redundant DO terms are largely removed. Using these methods, we constructed a simplified vocabulary list from the DO called Disease Ontology Lite (DOLite). We demonstrated that DOLite results in more interpretable results than DO for gene-disease association tests. The resultant DOLite has been used in the Functional Disease Ontology (FunDO) Web application at http://www.projects.bioinformatics.northwestern.edu/fundo.\n%K Computational Biology/*methods\n%K Data Interpretation, Statistical\n%K Database Management Systems\n%K Databases, Genetic/classification\n%K Disease/*genetics\n%K Genome\n%K Terminology as Topic\n%K *Vocabulary, Controlled\n%+ The Biomedical Informatics Center, Northwestern University, Chicago, IL 60611, USA.","volume":"25","pages":"i63-i68","year":"2009","issue":"12","issn":null,"pubmed":"19478018","electronic_publication_date":"2009-05-30","citation_cnt":0,"authors":"Du, P.\nFeng, G.\nFlatow, J.\nSong, J.\nHolko, M.\nKibbe, W. A.\nLin, S. M.","status":"MEDLINE","created_id":null,"created_ip":null}}])
create_response(body)
end


def create_response(body)
  mock_model(Net::HTTPOK, :body => body)
end