# == Schema Information
# Schema version: 20100817202539
#
# Table name: users
#
#  id             :integer         not null, primary key
#  first_name     :string(255)
#  middle_name    :string(255)
#  last_name      :string(255)
#  title          :string(255)
#  business_phone :string(255)
#  fax            :string(255)
#  email          :string(255)
#  username       :string(255)
#  nu_employeeid  :string(255)
#  personnelid    :string(255)
#  address        :string(255)
#  city           :string(255)
#  state          :string(255)
#  country        :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class User < ActiveRecord::Base
  include Bcsec


end
