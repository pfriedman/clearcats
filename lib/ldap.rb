require 'net/ldap'

class Ldap

  ATTRIBUTES = ["title", "displayname", "givenname", "cn", "sn", "mail", "ou", 
                "uid", "uidnumber", "dn", 
                "facsimiletelephonenumber", "telephonenumber", "postaladdress"]

  def retrieve_entry_by_netid(netid)
    retrieve_entry(netid, "uid")
  end
  
  def retrieve_entry_by_email(email)
    retrieve_entry(email, "mail")
  end
  
  def retrieve_entry(value, key = "uid")
    process_entry(Net::LDAP::Filter.eq(key, value))
  end

  private
  
    #
    # NOTE!!
    # See: /config/ldap_config.yml file for configuration
    #
    def get_connection
      Net::LDAP.new({:host => LDAP_CONFIG['server'], :port => LDAP_CONFIG['port']})
    end
  
    def process_entry(user_filter)
      entry   = nil
      entries = get_connection.search(:base => LDAP_CONFIG['treebase'], :filter => user_filter)
      entry   = clean_ldap_entry(entries[0]) unless entries.blank?
      entry
    end
  
    def clean_ldap_entry(entry)
      ATTRIBUTES.each do |key|
        entry[key] = clean_ldap_value(entry[key])
      end
      entry
    end
    
    def clean_ldap_value(val)
      return nil if val.nil?
      
      if val.kind_of?(Array)
        return nil if val.length == 0
        val = clean_ldap_value(val[0].to_s)
      else
        val = val.to_s.gsub("\n", "").gsub("-", "").gsub("[", "").gsub("]", "").strip
      end
      val
    end
  
end