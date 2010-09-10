module Bcsec::Authorities
  class Netid
    
    def initialize(config)
      # NOOP
    end
    
    def valid_credentials?(kind, *credentials)
      username, password = credentials
      return Bcsec::User.new(username, :ClearCATS)
    end
    
  end
end
# ATTRIBUTES = :username, :first_name, :middle_name, :last_name,
#   :title, :business_phone, :fax, :email, :address, :city, :state, :country,
#   :employee_id, :personnel_id