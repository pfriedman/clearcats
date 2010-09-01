class Turbocats::Base < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "turbo_ctsa_#{Rails.env}"
end