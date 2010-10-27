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
end

Factory.define :phs_organization, :class => "PhsOrganization" do |org|
  org.code "po code"
  org.name "phs_organization name"
end

Factory.define :country do |c|
  c.name "country name"
end

Factory.define :us_state do |s|
  s.name "state"
  s.abbreviation "st"
end

Factory.define :degree_type_one, :class => "DegreeTypeOne" do |dt|
  dt.name "dt1 name"
end

Factory.define :degree_type_two, :class => "DegreeTypeTwo" do |dt|
  dt.name "dt2 name"
end

Factory.define :ethnic_type do |et|
  et.name "ethnic_type name"
end

Factory.define :race_type do |rt|
  rt.name "race_type name"
end

Factory.define :organizational_unit do |ou|
  ou.name                         "organizational_unit name"
  ou.abbreviation                 "ou"
  ou.cc_pers_affiliate_identifier "cc_pers"
end

Factory.define :service_line do |sl|
  sl.name "service line name"
  sl.organizational_unit { |a| a.association(:organizational_unit) }
end

Factory.define :department do |dept|
  dept.name "department name"
end

Factory.define :institution_position do |p|
  p.name "position name"
end

Factory.define :activity_type do |t|
  t.name         "activity type name"
  t.service_line { |a| a.association(:service_line) }
end


Factory.sequence :netid do |n|
  "netid_#{n}"
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
  p.netid                  { Factory.next(:netid) }
  p.training_type          nil
  p.trainee_status         nil

  p.country             { |a| a.association(:country) }
  p.degree_type_one     { |a| a.association(:degree_type_one) }
  p.degree_type_two     { |a| a.association(:degree_type_two) }
  p.specialty           { |a| a.association(:specialty) }
end

Factory.define :client do |p|
  p.first_name             "first_name"
  p.middle_name            "middle_name"
  p.last_name              "last_name"
  p.phone                  "phone"
  p.sequence(:email)       { |n| "email#{n}@dev.null" }
  p.last_four_of_ssn       "four"
  p.department_affiliation "dept"
  p.school_affiliation     "school"
  p.era_commons_username   "era_commons"
  p.employeeid             "emplid"
  p.netid                  { Factory.next(:netid) }
  p.training_type          nil
  p.trainee_status         nil
  p.ctsa_reporting_years_mask 1
  
  p.country             { |a| a.association(:country) }
  p.degree_type_one     { |a| a.association(:degree_type_one) }
  p.degree_type_two     { |a| a.association(:degree_type_two) }
  p.specialty           { |a| a.association(:specialty) }
end


Factory.define :service do |svc|
  svc.service_line { |a| a.association(:service_line) }
  svc.person       { |a| a.association(:person) }
end

Factory.define :award do |a|
  a.person            { |a| a.association(:person) }
  a.organization      { |a| a.association(:phs_organization) }
  a.activity_code     { |a| a.association(:activity_code) }
  a.grant_number      "grant number"
  a.grant_title       "grant title"
  a.grant_amount      11.00
  a.budget_identifier "NORTHWESTU00000039703000"
  a.ctsa_reporting_years_mask 1
end

Factory.define :award_detail do |a|
  a.award { |a| a.association(:award) }
  a.budget_number "NORTHWESTU0000003970300060001"
end

Factory.define :sponsor do |sponsor|
  sponsor.name "sponsor name"
end

Factory.define :publication do |pub|
  pub.pmcid             "pmcid"
  pub.pmid              "pmid"
  pub.nihms_number      "nihms_number"
  pub.publication_date  Date.today
  pub.person            { |a| a.association(:person) }
  pub.abstract          "boogadeehoo"
  pub.title             "title"
  pub.cited             true
  pub.missing_pmcid_reason ""
  pub.ctsa_reporting_years_mask 1
end

Factory.define :approval do |a|
  a.tracking_number         "tracking_number"
  a.approval_type           "Other"
  a.project_title           "project_title"
  a.approval_date           Time.now
  a.nucats_assisted         false
  a.principal_investigator  "principal_investigator"
end

Factory.define :ctsa_report do |r|
  r.created_by      { |a| a.association(:user) }
  r.reporting_year  Time.now.year
  r.grant_number    "123456"
  r.finalized       false
  r.has_errors      false
end

Factory.define :participating_organization do |po|
  po.name "name"
  po.city "Chicago"
  po.country  { |c| c.association(:country) }
  po.us_state { |s| s.association(:us_state) }
  po.reporting_year 2525
end

Factory.define :user do |u|
  u.first_name     "first_name"
  u.middle_name    "middle_name"
  u.last_name      "last_name"
  u.title          "title"
  u.business_phone "business_phone"
  u.fax            "fax"
  u.email          "email"
  u.username       "username"
  u.employeeid     "employeeid"
  u.personnelid    "personnelid"
  u.address        "address"
  u.city           "city"
  u.state          "state"
  u.country             { |a| a.association(:country) }
  u.organizational_unit { |a| a.association(:organizational_unit) }
end