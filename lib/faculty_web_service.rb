require 'net/http'
require 'uri'

class FacultyWebService

  DEFAULT_HOST_URL = "https://clinical-rails-stg.nubic.northwestern.edu/ws-faculty/"
  # url to faculty_ws on staging: https://clinical-rails-stg.nubic.northwestern.edu/ws-faculty/
  #
  # /faculty/:netid
  #
  # /faculty/
  #
  # /faculty/?last_name=:lname
  #
  def self.locate(params, importing = false)
    @importing = importing
    results = []

    uri, req = create_faculty_request(params)

    begin
      resp = make_request(uri, req)
      results = parse_faculty_response(resp.body) unless resp.body.blank?

    rescue Exception => e
      Rails.logger.error("FacultyWebService.locate - Exception [#{e.message}] occurred when calling web service.\n")
      Rails.logger.error(e.backtrace.join("\n"))
    end

    return results
  end

  def self.locate_one(params)
    results = FacultyWebService.locate(params)
    return nil if results.empty?
    return results.first
  end
  
  def self.award_organizations
    results = []

    uri, req = create_award_request(nil)

    begin
      resp = make_request(uri, req)

      unless resp.body.blank?
        value = ActiveSupport::JSON.decode(resp.body)
        value.each do |attributes|
          results << Organization.find_or_create_by_name(attributes["name"])
        end
      end
    rescue Exception => e
      Rails.logger.error("FacultyWebService.award_organizations - Exception [#{e.message}] occurred when calling web service.\n")
      Rails.logger.error(e.backtrace.join("\n"))
    end

    return results
  end
  
  def self.awards_for_employee(params)
    @seen_awards = Hash.new
    results = []
    
    uri, req = create_award_request(params)

    begin
      resp = make_request(uri, req)
      results = parse_award_response(resp.body) unless resp.body.blank?

      person = Person.find_by_employeeid(params[:employeeid])
      results.each do |r|
        r.person = person
        r.save!
      end

    rescue Exception => e
      Rails.logger.error("FacultyWebService.awards_for_employee - Exception [#{e.message}] occurred when calling web service.\n")
      Rails.logger.error(e.backtrace.join("\n"))
    end

    return results
  end

  private

    def self.create_award_request(params)
      url   = ClearCats::ExternalServices::Resource.new(:faculty_ws, :ws).to_s ||= DEFAULT_HOST_URL
      path = "/awards/"

      if params.nil?
        path += "organizations"
      elsif !params[:employeeid].blank?
        path += "#{URI::escape(params[:employeeid])}"
      end

      uri = URI.parse(url + path)

      get_request = uri.path

      req = Net::HTTP::Get.new(get_request)
      return uri, req
    end

    def self.create_faculty_request(params)
      url   = ClearCats::ExternalServices::Resource.new(:faculty_ws, :ws).to_s ||= DEFAULT_HOST_URL
      query = nil
      path = "/faculty/"

      if !params[:netid].blank?
        query = "netid=#{URI::escape(params[:netid])}"
      elsif !params[:employeeid].blank?
        query = "employeeid=#{URI::escape(params[:employeeid])}"
      elsif !params[:last_name].blank?
        query = "last_name=#{URI::escape(params[:last_name])}"
      end

      uri = URI.parse(url + path)
      get_request = uri.path

      if query
        get_request += "?" + query
      end

      req = Net::HTTP::Get.new(get_request)
      return uri, req
    end

    def self.make_request(uri, req)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.is_a?(URI::HTTPS)
      resp = http.start { |h| h.request(req) }
      return resp
    end

    def self.instantiate_person(attributes)
      person = determine_person_to_instantiate(attributes)

      if !person.edited_by_user?
        attributes.each { |name, value| person.send("#{name.to_s}=", value) if person.respond_to?("#{name.to_s}=") }
      
        # use ldap over faculty db
        begin
          ldap_entry = Ldap.new.retrieve_entry_by_netid(attributes["netid"])
          ldap_entry.attribute_names.each { |key| person.send("#{key}=", ldap_entry[key].to_s) if person.respond_to?("#{key}=") } unless ldap_entry.blank?
      
          dept = Department.find_by_externalid(person.dept_id)
          person.department = dept if dept
          if person.valid?
            person.save!
            Rails.logger.info("FacultyWebService.instantiate_person - [#{person.netid}] #{person.to_s}")
          end
        rescue
          # NOOP
        end
      end
      return person
    end
    
    def self.instantiate_award(attributes)
      begin
        budget_number     = attributes["budget_number"]
        budget_identifier = budget_number[0,24]
        
        award = get_award(budget_identifier)
        sponsor_attributes, award_attributes, award_detail_attributes = extract_attributes(attributes)

        if !award.edited_by_user?
          sponsor = award.sponsor.blank? ? Sponsor.new : award.sponsor
          sponsor_attributes.each { |name, value| sponsor.send(name.to_s + '=', value) }
          award.sponsor = sponsor unless sponsor.nil?
          
          award_attributes.each { |name, value| award.send(name.to_s + '=', value) }

          if award.department.blank?
            dept = Department.find_or_create_by_name(attributes["department"])
            award.department = dept if dept
          end
        end
        
        award_detail = award.award_details.select { |detail| detail.budget_number == budget_number }.first
        award_detail = AwardDetail.new(:award => award) if award_detail.nil?
        
        award_detail_attributes.each { |name, value| award_detail.send(name.to_s + '=', value) }
        award.award_details << award_detail
        
        Rails.logger.info("FacultyWebService.instantiate_award - #{award.inspect}")
        
        @seen_awards[budget_identifier] = award
        
        return award
      rescue Exception => e
        Rails.logger.error("FacultyWebService.instantiate_award - Error occurred #{e} \n #{e.backtrace.join('\n')}")
      end
    end

    def self.get_award(budget_identifier)
      award = @seen_awards[budget_identifier] if @seen_awards.has_key?(budget_identifier)
      award = Award.find_by_budget_identifier(budget_identifier) if award.nil?
      award = Award.new(:budget_identifier => budget_identifier) if award.nil?
      award
    end

    def self.extract_attributes(attributes)
      award_detail_fields = ["budget_period", "budget_period_start_date", "budget_period_end_date", "budget_period_direct_cost", "award_end_date", "award_begin_date",
                             "budget_period_direct_and_indirect_cost", "budget_number", "direct_amount", "indirect_amount", "total_amount" ]

      sponsor_attributes      = Hash.new
      award_attributes        = Hash.new
      award_detail_attributes = Hash.new

      attributes.each do |name, value|
        if name != "sponsor_award_number" and name.include?("sponsor")
          sponsor_attributes[name] = value
        elsif award_detail_fields.include?(name)
          award_detail_attributes[name] = value
        else
          award_attributes[name] = value
        end
      end
      [sponsor_attributes, award_attributes, award_detail_attributes]
    end

    def self.parse_faculty_response(body)
      results = []
      value = ActiveSupport::JSON.decode(body)
      if value.is_a?(Array)
        value.each { |attributes| results << instantiate_person(attributes) }
      elsif value.is_a?(Hash)
        results << instantiate_person(value)
      end
      results.compact
    end
    
    def self.parse_award_response(body)
      results = []
      value = ActiveSupport::JSON.decode(body)
      value.each do |attributes|
        award = instantiate_award(attributes) 
        results << award if award and !results.include?(award)
      end
      results
    end

    def self.determine_person_to_instantiate(attributes)
      if @importing
        # when importing - attempt to match by loose criteria
        person = Person.find_by_last_name(attributes["last_name"])
        if person and person.first_name.strip != attributes["first_name"].strip
          person = find_person_by_identifier(attributes)
        end
      else
        person = find_person_by_identifier(attributes)
      end
      person
    end
    
    def self.find_person_by_identifier(attributes)
      person = nil
      person = Person.find_by_employeeid(attributes["employee_id"]) if person.nil? and !attributes["employee_id"].blank?
      person = Person.find_by_netid(attributes["netid"]) if person.nil? and !attributes["netid"].blank?
      person = Client.new if person.nil?
      person
    end

end