

class DataScrubber
  
  def self.update_service_creators
    creator_map = {
      "CECD"  => "mns521", 
      "CERC"  => "pfr957", 
      "RSP"   => "bfs326", 
      "CCR"   => "pcm777", 
      "CTI"   => "jab155", 
      "RTS&D" => "ltr435", 
      "NUBIC" => "aco454"
    }    
    Service.all.each do |svc| 
      if svc.service_line and svc.created_by.blank?
        svc.update_attribute(:created_by, creator_map[svc.organizational_unit.abbreviation])
      end
    end
  end
  
  def self.update_records_with_era_commons_usernames
    
    commons_name_map = get_commons_name_map_from_file
    
    Person.all(:conditions => "era_commons_username IS NULL").each do |pers| 
      eracn = commons_name_map[pers.employeeid.to_s]
      eracn = commons_name_map[pers.full_name] if eracn.blank?
      eracn = commons_name_map["#{pers.first_name} #{pers.last_name}"] if eracn.blank?
      
      pers.update_attribute(:era_commons_username, eracn) unless eracn.blank?
    end
    
  end
  
  def self.get_commons_name_map_from_file
    map = {}
    file = File.open(determine_file_path)
    
    FasterCSV.parse(file, :headers => true, :header_converters => :symbol) do |row|      
      map["#{row[:fname]} #{row[:lname]}"] = row[:commonsid]
      map["#{row[:employer_id]}"]          = row[:commonsid]
    end      
    map
  end

  private

    # TODO: FIXME: 
    # hack to work around naming issue in git
    def self.determine_file_path
      filename = "CommonsIDs"      
      if File.exists?("#{Rails.root}/lib/data/#{filename.downcase}.csv")
        return "#{Rails.root}/lib/data/#{filename.downcase}.csv"
      else
        return "#{Rails.root}/lib/data/#{filename}.csv"
      end
    end
  
end