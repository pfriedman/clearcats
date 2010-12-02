class ClientMerger
  
  def self.merge(eracn, netid)
    
    client_to_keep = Client.find_by_era_commons_username(eracn)
    client_to_kill = Client.find_by_netid(netid)
    
    client_to_keep.attribute_names.each do |attr_name|
      
      client_to_keep[attr_name] = client_to_kill[attr_name] if client_to_keep[attr_name].blank?
      
    end
    
    client_to_kill.services.each { |svc| client_to_keep.services << svc }
    
    client_to_kill.destroy
    client_to_keep.save!
    
  end
  
end

