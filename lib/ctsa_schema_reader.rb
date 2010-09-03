require 'rexml/element'
require 'rexml/document'

class CtsaSchemaReader

  attr_accessor :file_path, :xml_schema
  
  def initialize(file_path)
    @file_path = file_path
    
    raise "Please supply a valid document path - was given #{@file_path}" if !File.exists?(@file_path)
    
    @xml_schema = REXML::Document.new(File.open(@file_path, 'r'))
  end
  
  # Process
  
  def process_activity_codes
    process_model("activity_code_list", " is ", ActivityCode)
  end

  def process_non_phs_organizations
    process_model("non_phs_organization_list", " is ", NonPhsOrganization)
  end
  
  def process_phs_organizations
    process_model("phs_organization_list", " is ", PhsOrganization)
  end
  
  def process_countries
    element = @xml_schema.root.elements[node_path("country_list", :child_node_path => "restriction")]
    element.children.each do |node| 
      if node.kind_of? REXML::Element and node.attributes['value']
        Country.find_or_create_by_name(node.attributes['value']) 
      end
    end
  end
  
  def process_us_states
    @xml_schema.root.elements["xs:simpleType[@name='state_code']/xs:restriction/xs:annotation"].children.each do |a|
      if a.kind_of? REXML::Element
        abbr = a.text.split()[0]
        name = a.text.sub(abbr, '').strip
        UsState.find_or_create_by_name_and_abbreviation(name, abbr)
      end
    end
  end
  
  def process_specialties
    process_model("specialty_list", "-", Specialty)
  end
  
  def process_degree_type_ones
    process_enumeration_model("degree_types_1", DegreeTypeOne)
  end
  
  def process_degree_type_twos
    process_enumeration_model("degree_types_2", DegreeTypeTwo)
  end
  
  def process_ethnic_types
    process_complex_model("ethnic_type", EthnicType)
  end
  
  def process_race_types
    process_complex_model("race_type", RaceType, :child_node_path => "sequence")
  end
  
  # Call all process_ methods
  def process
    process_activity_codes
    process_non_phs_organizations
    process_phs_organizations
    process_countries
    process_us_states
    process_specialties
    process_degree_type_ones
    process_degree_type_twos
    process_ethnic_types
    process_race_types
  end

  # Output
  
  def output_activity_code_list
    output_element(@xml_schema.root.elements[node_path("activity_code_list")], " is ")
    return
  end
  
  def output_non_phs_organization_list
    output_element(@xml_schema.root.elements[node_path("non_phs_organization_list")], " is ")
    return
  end
  
  def output_phs_organization_list
    output_element(@xml_schema.root.elements[node_path("phs_organization_list")], " is ")
    return
  end
  
  def output_country_list
    @xml_schema.root.elements[node_path("country_list", :child_node_path => "restriction")].children.each do |a| 
      puts %Q("#{a.attributes['value']}" => "#{a.attributes['value']}",) if a.kind_of? REXML::Element and a.attributes['value']
    end
    return
  end
  
  def output_us_state_codes
    @xml_schema.root.elements["xs:simpleType[@name='state_code']/xs:restriction/xs:annotation"].children.each do |a|
      if a.kind_of? REXML::Element
        txt = a.text
        abbr = a.text.split()[0]
        name = txt.sub(abbr, '').strip
        puts %Q("#{abbr}" => "#{name}",")
      end
    end
    return
  end
    
  def output_specialty_list
    output_element(@xml_schema.root.elements[node_path("specialty_list")], "-")
    return
  end
  
  def output_degree_type_one_list
    names, abbrs = restriction_names_and_abbreviations("degree_types_1")
    names.size.times { |idx| puts "#{abbrs[idx]} - #{names[idx]}" }
  end
  
  def output_degree_type_two_list
    names, abbrs = restriction_names_and_abbreviations("degree_types_2")
    names.size.times { |idx| puts "#{abbrs[idx]} - #{names[idx]}" }
  end
  
  def output_ethnic_types
    @xml_schema.root.elements[node_path("ethnic_type", :named_node => "complexType", :child_node_path => "all")].children.each do |a| 
      puts %Q("#{a.attributes['name']}",) if a.kind_of? REXML::Element and a.attributes['name']
    end
    return
  end
  
  def output_race_types
    @xml_schema.root.elements[node_path("race_type", :named_node => "complexType", :child_node_path => "sequence")].children.each do |a| 
      puts %Q("#{a.attributes['name']}",) if a.kind_of? REXML::Element and a.attributes['name']
    end
    return
  end
  
  private

    def node_path(attribute_name, options = {})
      defaults = {:named_node => "simpleType", :child_node_path => "annotation" }
      options = defaults.merge(options)
      if !options[:child_node_path].start_with?("xs:")
        options[:child_node_path] = "xs:#{options[:child_node_path]}"
      end
      return "xs:#{options[:named_node]}[@name='#{attribute_name}']/#{options[:child_node_path]}"
    end
    
    def output_element(element, delim)
      element.children.each do |a|
        puts %Q("#{a.text.split(delim)[0]}" => "#{a.text.split(delim)[1]}",) if a.kind_of? REXML::Element
      end
      return
    end
    
    def process_model(node_name, delimiter, cls)
      element = @xml_schema.root.elements[node_path(node_name)]
      element.children.each do |node|
        if node.kind_of? REXML::Element
          data = node.text.split(delimiter)
          cls.find_or_create_by_code_and_name(data[0], data[1]) 
        end
      end
    end
    
    def process_complex_model(node_name, cls, options = {})
      defaults = {:named_node => "complexType", :child_node_path => "all"}
      options  = defaults.merge(options)
      element  = @xml_schema.root.elements[node_path(node_name, options)]
      element.children.each do |node|
        if node.kind_of?(REXML::Element) and node.attributes['name']
          name = humanize(node.attributes['name'])
          cls.find_or_create_by_name(name)
        end
      end
    end
    
    def process_enumeration_model(node_name, cls)
      names, abbrs = restriction_names_and_abbreviations(node_name)
      if names.size == abbrs.size
        names.size.times do |idx|
          cls.find_or_create_by_abbreviation_and_name(abbrs[idx], names[idx]) 
        end
      end
    end
    
    def restriction_names_and_abbreviations(node_name)
      name_element = @xml_schema.root.elements[node_path(node_name, :child_node_path => "xs:restriction/xs:annotation")]
      abbr_element = @xml_schema.root.elements[node_path(node_name, :child_node_path => "restriction")]
      
      names = []
      name_element.children.each do |a|
        names << "#{a.text}" if a.kind_of? REXML::Element
      end
      
      abbrs = []
      abbr_element.children.each do |a|
        abbrs << "#{a.attributes['value']}" if a.kind_of? REXML::Element and a.name == "enumeration" and a.attributes['value']
      end
      return names, abbrs
      
    end
    
    def humanize(value)
      if value.include?("_")
        value.gsub("_", " ")
      else
        value.titleize
      end
    end
end
