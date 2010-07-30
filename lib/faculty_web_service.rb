require 'net/http'
require 'uri'

class FacultyWebService

  NON_SSL_ENVS = ["development", "test", "cucumber", "culerity"]

  DEFAULT_HOST_URL = "https://clinical-rails-stg.nubic.northwestern.edu/ws-faculty/"
  # url to faculty_ws on staging: https://clinical-rails-stg.nubic.northwestern.edu/ws-faculty/
  #
  # /faculty/show/:netid
  #
  # /faculty/list
  #
  # /faculty/search?last_name=:lname
  #
  def self.locate(params)

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

    results = []

    uri, req = create_award_request(params)

    begin
      resp = make_request(uri, req)
      results = parse_award_response(resp.body) unless resp.body.blank?

      person = Person.find_by_employeeid(params[:employeeid])
      results.each { |r| r.person = person; r.save!; }

    rescue Exception => e
      Rails.logger.error("FacultyWebService.awards_for_employee - Exception [#{e.message}] occurred when calling web service.\n")
      Rails.logger.error(e.backtrace.join("\n"))
    end

    return results
  end

  private

    def self.create_award_request(params)
      url   = ClearCats::ExternalServices::Resource.new(:faculty_ws, :ws).to_s ||= DEFAULT_HOST_URL
      path = "/award/"

      if params.nil?
        path += "organizations"
      elsif !params[:employeeid].blank?
        path += "list/#{URI::escape(params[:employeeid])}"
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
        path += "show/#{URI::escape(params[:netid])}"
      elsif !params[:last_name].blank?
        path += "search"
        query = "last_name=#{URI::escape(params[:last_name])}"
      else
        path += "list"
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
      http.use_ssl = true unless NON_SSL_ENVS.include?(Rails.env)
      resp = http.start { |h| h.request(req) }
      return resp
    end

    def self.instantiate_person(attributes)
      person = Person.find_by_netid(attributes["netid"])
      person = Person.new if person.nil?

      attributes.each { |name, value| person.send(name.to_s + '=', value) }

      dept = Department.find_by_externalid(person.dept_id)
      person.department = dept if dept
      person.save!

      Rails.logger.info("FacultyWebService.instantiate_person - [#{person.netid}] #{person.to_s}")

      return person
    end
    
    def self.instantiate_award(attributes)
      award = Award.find_by_budget_number(attributes["budget_number"])
      award = Award.new if award.nil?

      sponsor = nil
      attributes.each do |name, value|
        if name.include?("sponsor") and name != "sponsor_award_number"
          sponsor ||= Sponsor.new
          sponsor.send(name.to_s + '=', value)
        else
          award.send(name.to_s + '=', value)
        end
      end
      award.sponsor = sponsor

      dept = Department.find_or_create_by_name(attributes["department"])
      award.department = dept if dept
      award.save!

      Rails.logger.info("FacultyWebService.instantiate_award - #{award.inspect}")

      return award
    end

    def self.parse_faculty_response(body)
      results = []
      value = ActiveSupport::JSON.decode(body)
      if value.is_a?(Array)
        value.each { |attributes| results << instantiate_person(attributes) }
      elsif value.is_a?(Hash)
        results << instantiate_person(value)
      end
      results
    end
    
    def self.parse_award_response(body)
      results = []
      value = ActiveSupport::JSON.decode(body)
      value.each { |attributes| results << instantiate_award(attributes) }
      results
    end

end