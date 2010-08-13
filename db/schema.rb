# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100812161634) do

  create_table "activity_codes", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_types", :force => true do |t|
    t.string   "name"
    t.integer  "service_line_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approvals", :force => true do |t|
    t.string   "tracking_number"
    t.string   "institution"
    t.string   "approval_type"
    t.string   "project_title"
    t.string   "approval_date"
    t.boolean  "nucats_assisted"
    t.string   "principal_investigator"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "awards", :force => true do |t|
    t.string   "grant_number"
    t.string   "years_of_award"
    t.string   "grant_title",                            :limit => 2500
    t.float    "grant_amount"
    t.integer  "person_id"
    t.integer  "investigator_id"
    t.string   "role"
    t.string   "parent_institution_number"
    t.string   "institution_number"
    t.string   "subproject_number"
    t.string   "ctsa_award_type_award_number"
    t.string   "budget_period"
    t.date     "budget_period_start_date"
    t.date     "budget_period_end_date"
    t.float    "budget_period_direct_cost"
    t.float    "budget_period_direct_and_indirect_cost"
    t.date     "project_period_start_date"
    t.date     "project_period_end_date"
    t.float    "project_period_total_cost"
    t.float    "total_project_cost"
    t.integer  "ctsa_award_type_id"
    t.string   "ctsa_award_type_type"
    t.string   "proposal_status"
    t.string   "award_status"
    t.string   "sponsor_award_number"
    t.string   "budget_number"
    t.float    "direct_amount"
    t.float    "indirect_amount"
    t.float    "total_amount"
    t.boolean  "nucats_assisted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sponsor_id"
    t.integer  "originating_sponsor_id"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "degree_types", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "externalid"
    t.string   "entity_name"
    t.string   "school"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "name"
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  create_table "ethnic_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institution_positions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institution_positions_people", :id => false, :force => true do |t|
    t.integer "institution_position_id"
    t.integer "person_id"
  end

  create_table "organizational_services", :force => true do |t|
    t.integer  "service_line_id"
    t.integer  "organizational_unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizational_units", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "type"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "netid"
    t.string   "email"
    t.string   "department_affiliation"
    t.string   "school_affiliation"
    t.string   "last_four_of_ssn"
    t.string   "phone"
    t.string   "era_commons_username"
    t.string   "employeeid"
    t.integer  "department_id"
    t.integer  "degree_type_one_id"
    t.integer  "degree_type_two_id"
    t.integer  "specialty_id"
    t.integer  "country_id"
    t.integer  "ethnic_type_id"
    t.integer  "race_type_id"
    t.boolean  "disadvantaged_background"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "human_subject_protection_training_institution"
    t.date     "human_subject_protection_training_date"
    t.boolean  "service_rendered",                              :default => false
  end

  create_table "publications", :force => true do |t|
    t.string   "pmcid"
    t.string   "pmid"
    t.string   "nihms_number"
    t.date     "publication_date"
    t.integer  "person_id"
    t.text     "abstract"
    t.string   "title",            :limit => 1000
    t.boolean  "nucats_assisted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "race_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_lines", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.integer  "service_line_id"
    t.integer  "person_id"
    t.integer  "created_by_id"
    t.date     "entered_on"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "specialties", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsors", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "sponsor_type_description"
    t.string   "sponsor_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "business_phone"
    t.string   "fax"
    t.string   "email"
    t.string   "username"
    t.string   "nu_employeeid"
    t.string   "personnelid"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "users_username_idx", :unique => true

end
