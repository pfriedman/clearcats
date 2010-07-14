# http://github.com/thoughtbot/factory_girl/tree/master
require 'rubygems'
require 'factory_girl'

Factory.define :specialty do |s|
  s.code "specialty code"
  s.name "specialty name"
end

Factory.define :activity_code do |a|
  a.code "activity code"
  a.name "activity_code name"
end

Factory.define :non_phs_organization, :class => "NonPhsOrganization" do |org|
  org.code "npo code"
  org.name "non_phs_organization name"
  # org.type "NonPhsOrganization"
end

Factory.define :phs_organization, :class => "PhsOrganization" do |org|
  org.code "po code"
  org.name "phs_organization name"
  # org.type "PhsOrganization"
end

Factory.define :country do |c|
  c.name "country name"
end

Factory.define :degree_type_one, :class => "DegreeTypeOne" do |dt|
  # dt.type "DegreeTypeOne"
  dt.name "dt1 name"
end

Factory.define :degree_type_two, :class => "DegreeTypeTwo" do |dt|
  # dt.type "DegreeTypeTwo"
  dt.name "dt2 name"
end

Factory.define :ethnic_type do |et|
  et.name "ethnic_type name"
end

Factory.define :race_type do |rt|
  rt.name "race_type name"
end

Factory.define :organizational_unit do |ou|
  ou.name         "organizational_unit name"
  ou.abbreviation "ou"
end

Factory.define :service_line do |sl|
  sl.name "service line name"
end

Factory.define :department do |dept|
  dept.name "department name"
end

Factory.define :institution_position do |p|
  p.name "position name"
end

Factory.define :organizational_service do |org_svc|
  org_svc.organizational_unit { |a| a.association(:organizational_unit) }
  org_svc.service_line        { |a| a.association(:service_line) }
end

Factory.define :activity_type do |t|
  t.name         "activity type name"
  t.service_line { |a| a.association(:service_line) }
end

Factory.define :person do |p|
  p.first_name             "first_name"
  p.middle_name            "middle_name"
  p.last_name              "last_name"
  p.phone                  "phone"
  p.sequence(:email)       { |n| "email#{n}@dev.null" }
  p.last_four_of_ssn       "four"
  p.department_affiliation "dept"
  p.school_affiliation     "school"
  p.era_commons_username   "era_commons"

  p.country             { |a| a.association(:country) }
  p.degree_type_one     { |a| a.association(:degree_type_one) }
  p.degree_type_two     { |a| a.association(:degree_type_two) }
  p.specialty           { |a| a.association(:specialty) }
end

