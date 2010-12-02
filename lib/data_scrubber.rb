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
  
end