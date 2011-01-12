require 'net/http'
require 'uri'

class EnotisWebService

  DEFAULT_HOST_URL = "https://enotis.northwestern.edu/roles"
  
  def self.approvals(params)
    @person = Person.find_by_netid(params[:netid])
    results = []
    
    uri, req = create_approval_request(params[:netid])

    begin
      resp = make_request(uri, req)
      results = parse_approval_response(resp.body) unless resp.body.blank?

      results.each do |r|
        r.person = @person
        r.save!
      end

    rescue Exception => e
      Rails.logger.error("EnotisWebService.approvals - Exception [#{e.message}] occurred when calling web service.\n")
      Rails.logger.error(e.backtrace.join("\n"))
    end

    return results
  end

  private

    def self.create_approval_request(netid)
      url  = ClearCats::ExternalServices::Resource.new(:enotis, :roles).to_s ||= DEFAULT_HOST_URL
      path = "/#{netid}.json"
      
      uri = URI.parse(url + path)
      req = Net::HTTP::Get.new(uri.path)
      return uri, req
    end

    def self.make_request(uri, req)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.is_a?(URI::HTTPS)
        http.use_ssl = true 
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      resp = http.start { |h| h.request(req) }
      return resp
    end

    def self.instantiate_approval(attributes)
      approval = determine_approval_to_instantiate(attributes)

      if approval.new_record?
        
        attributes.each { |name, value| approval.send("#{name.to_s}=", value) if approval.respond_to?("#{name.to_s}=") }

        approval.save! if approval.valid?

      end
      return approval
    end
    
    def self.parse_approval_response(body)
      results = []
      value = ActiveSupport::JSON.decode(body)
      value.each do |attributes|
        approval = instantiate_approval(attributes) if principal_investigator?(attributes["project_role"])
        results << approval if approval and !results.include?(approval)
      end
      results
    end

    def self.determine_approval_to_instantiate(attributes)
      tracking_number = attributes["irb_number"]
      approval = Approval.find_by_tracking_number(tracking_number) unless tracking_number.blank?
      approval = Approval.new(:approval_type => "IRB", :institution => "NUIRB", :person => @person) if approval.nil?
      approval
    end
    
    
    # TODO: determine if the IRB approval should be 
    def self.principal_investigator?(txt)
      if txt.length == 2
        return txt.downcase == "pi"
      else
        return "principal investigator".levenshtein_distance(txt) < 3
      end
    end

end