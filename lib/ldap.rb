require 'net/ldap'

class Ldap

  ATTRIBUTES = ["title", "ou", "dn", "cn", "mail", 
                "displayname", "givenname", "sn", "uidnumber", "uid",
                "facsimiletelephonenumber", "telephonenumber", "postaladdress"]

  def retrieve_entry(uid)
    process_entry(Net::LDAP::Filter.eq("uid", uid))
  end

  private
  
    #
    # NOTE!!
    # See: /config/ldap_config.yml file for configuration
    #
    def get_connnection
      if LDAP_CONFIG['username'].blank?
        return Net::LDAP.new({:host => LDAP_CONFIG['server'], :port => LDAP_CONFIG['port']})
      else
        return Net::LDAP.new({:host => LDAP_CONFIG['server'], 
                       :port => LDAP_CONFIG['port'],
                       :encryption => :simple_tls,
                       :auth => { :method => :simple, 
                                  :username => LDAP_CONFIG['username'], 
                                  :password => LDAP_CONFIG['password'] }} )
      end
    end
  
    def process_entry(user_filter)
      entry   = nil
      entries = get_connnection.search(:base => LDAP_CONFIG['treebase'], :filter => user_filter)
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
        val = clean_ldap_value(val[0])
      else
        val.gsub(/[\n-\[\]]*/,"").strip
      end
      
      val
    end
  
end