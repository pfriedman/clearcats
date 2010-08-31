class ResponseSet < ActiveRecord::Base
  
  belongs_to :person
  belongs_to :service_line
  
end