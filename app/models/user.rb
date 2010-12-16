# == Schema Information
# Schema version: 20101216175350
#
# Table name: people
#
#  id                                            :integer         not null, primary key
#  type                                          :string(255)
#  first_name                                    :string(255)
#  middle_name                                   :string(255)
#  last_name                                     :string(255)
#  netid                                         :string(255)
#  email                                         :string(255)
#  department_affiliation                        :string(255)
#  school_affiliation                            :string(255)
#  last_four_of_ssn                              :string(255)
#  phone                                         :string(255)
#  era_commons_username                          :string(255)
#  employeeid                                    :string(255)
#  department_id                                 :integer
#  personnelid                                   :string(255)
#  address                                       :string(255)
#  city                                          :string(255)
#  state                                         :string(255)
#  edited_by_user                                :boolean
#  organizational_unit_id                        :integer
#  degree_type_one_id                            :integer
#  degree_type_two_id                            :integer
#  specialty_id                                  :integer
#  country_id                                    :integer
#  ethnic_type_id                                :integer
#  race_type_id                                  :integer
#  disadvantaged_background                      :boolean
#  created_at                                    :datetime
#  updated_at                                    :datetime
#  human_subject_protection_training_institution :string(255)
#  human_subject_protection_training_date        :date
#  service_rendered                              :boolean
#  training_type                                 :string(255)
#  trainee_status                                :string(255)
#  has_disability                                :boolean
#  gender                                        :string(255)
#  title                                         :string(255)
#  fax                                           :string(255)
#  edited                                        :boolean
#  imported                                      :boolean
#  ctsa_reporting_years_mask                     :integer
#  system_administrator                          :boolean
#  created_by                                    :string(255)
#  updated_by                                    :string(255)
#  mentor_era_commons_username                   :string(255)
#  appointment_date                              :date
#  end_date                                      :date
#

class User < Person
  include Bcsec
  
  belongs_to :organizational_unit
  
  validates_presence_of :netid

end
