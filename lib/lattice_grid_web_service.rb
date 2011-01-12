require 'net/http'
require 'uri'

class LatticeGridWebService

  DEFAULT_HOST_URL = "http://rails-dev.bioinformatics.northwestern.edu/fsmpubs/"

  def self.investigators_search(search_term)
    results = []

    uri, req = create_investigator_search_request(search_term)

    begin
      resp = make_request(uri, req)
      value = ActiveSupport::JSON.decode(cleantext(resp.body))

      if value
        value.each do |attributes|
          investigator = instantiate_investigator(attributes["investigator"])
          results << investigator unless investigator.nil?
        end
      end

    rescue Exception => e
      Rails.logger.error("LatticeGridWebService.investigators_search - Exception [#{e.message}] occurred when calling web service.\n")
      Rails.logger.error(e.backtrace.join("\n"))
    end

    return results
  end
  
  def self.investigator_publications_search(netid)
    results = []

    url   = ClearCats::ExternalServices::Resource.new(:lattice_grid, :investigators).to_s
    path  = "/#{netid}/publications.json"

    uri = URI.parse(url + path)
    req = Net::HTTP::Get.new(uri.path)

    begin

      resp = make_request(uri, req)
      value = ActiveSupport::JSON.decode(cleantext(resp.body))
    
      if value
        person = find_or_create_person(netid)
        value.each do |attributes|
          results << instantiate_publication(attributes["abstract"]) 
        end
        results.each { |r| r.person = person; r.save! }
      end

    rescue Exception => e
      Rails.logger.error("LatticeGridWebService.investigator_publications_search - Exception [#{e.message}] occurred when calling web service.\n")
      Rails.logger.error(e.backtrace.join("\n"))
    end

    return results
    
  end
  
  
  def self.is_investigator?(netid)
    
    result = false
    
    url   = ClearCats::ExternalServices::Resource.new(:lattice_grid, :investigators).to_s
    path  = "/#{netid}/show/1"

    uri = URI.parse(url + path)
    req = Net::HTTP::Get.new(uri.path)
    
    invalid_text = "Sorry - invalid username"
    
    begin

      resp = make_request(uri, req)

      result = resp.body.include?(invalid_text) ? false : true

    rescue Exception => e
      Rails.logger.error("LatticeGridWebService.investigator_publications_search - Exception [#{e.message}] occurred when calling web service.\n")
      Rails.logger.error(e.backtrace.join("\n"))
    end
    
    result
    
  end

  private

    def self.create_investigator_search_request(search_term)
      create_search_request(search_term, "investigators")
    end

    def self.create_search_request(search_term, action_name)

      url   = ClearCats::ExternalServices::Resource.new(:lattice_grid, :mesh).to_s
      path  = "/#{URI::escape(search_term)}/#{action_name}.json"

      uri = URI.parse(url + path)
      req = Net::HTTP::Get.new(uri.path)
      return uri, req
    end

    def self.make_request(uri, req)
      http = Net::HTTP.new(uri.host, uri.port)
      resp = http.start { |h| h.request(req) }
      return resp
    end

    def self.instantiate_investigator(attributes)
      person = find_or_create_person(attributes["username"])
      person
    end
    
    def self.instantiate_publication(attributes)
      pub = Publication.find_by_pmid(attributes["pubmed"])
      
      if pub.nil?
        pub = Publication.new
        attributes.each { |k, v| pub.send("#{k}=", v) if pub.respond_to?("#{k}=") }
      elsif pub.versions.empty?
        attributes.each { |k, v| pub.send("#{k}=", v) if pub.respond_to?("#{k}=") }
      end
      pub
    end
    
    def self.find_or_create_person(netid)
      person = Person.find_by_netid(netid)
      person = FacultyWebService.locate_one({:netid => netid}) if person.nil?
      person
    end
    
    def self.cleantext(txt)
      File.open("#{Rails.root}/log/lattice_grid.log", 'w') { |f| f.write(txt) }
      txt.gsub(/\022|\023|\024|\030|\031|\034|\035/,' ')
    end
    
end