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

ActiveRecord::Schema.define(:version => 20101110200934) do

  create_table "activity_codes", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_codes", ["code"], :name => "index_activity_codes_on_code"
  add_index "activity_codes", ["name"], :name => "index_activity_codes_on_name"

  create_table "activity_types", :force => true do |t|
    t.string   "name"
    t.integer  "service_line_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_types", ["name"], :name => "index_activity_types_on_name"
  add_index "activity_types", ["service_line_id"], :name => "index_activity_types_on_service_line_id"

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.integer  "weight"
    t.string   "response_class"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.boolean  "is_exclusive"
    t.boolean  "hide_label"
    t.integer  "display_length"
    t.string   "custom_class"
    t.string   "custom_renderer"
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

  add_index "approvals", ["person_id"], :name => "index_approvals_on_person_id"

  create_table "attachments", :force => true do |t|
    t.string   "name"
    t.integer  "reporting_year"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  create_table "award_details", :force => true do |t|
    t.integer  "award_id"
    t.string   "budget_period"
    t.date     "budget_period_start_date"
    t.date     "budget_period_end_date"
    t.float    "budget_period_direct_cost"
    t.float    "budget_period_direct_and_indirect_cost"
    t.string   "budget_number"
    t.float    "direct_amount"
    t.float    "indirect_amount"
    t.float    "total_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "award_details", ["budget_number"], :name => "index_award_details_on_budget_number"

  create_table "awards", :force => true do |t|
    t.string   "grant_number"
    t.string   "grant_title",                  :limit => 2500
    t.float    "grant_amount"
    t.integer  "person_id"
    t.integer  "investigator_id"
    t.string   "role"
    t.string   "parent_institution_number"
    t.string   "institution_number"
    t.string   "subproject_number"
    t.string   "ctsa_award_type_award_number"
    t.date     "project_period_start_date"
    t.date     "project_period_end_date"
    t.float    "project_period_total_cost"
    t.float    "total_project_cost"
    t.integer  "organization_id"
    t.string   "organization_type"
    t.integer  "activity_code_id"
    t.string   "proposal_status"
    t.string   "award_status"
    t.string   "sponsor_award_number"
    t.boolean  "nucats_assisted"
    t.string   "budget_identifier"
    t.boolean  "edited_by_user"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sponsor_id"
    t.integer  "originating_sponsor_id"
    t.integer  "ctsa_reporting_years_mask"
  end

  add_index "awards", ["activity_code_id"], :name => "index_awards_on_activity_code_id"
  add_index "awards", ["budget_identifier"], :name => "index_awards_on_budget_identifier"
  add_index "awards", ["investigator_id"], :name => "index_awards_on_investigator_id"
  add_index "awards", ["organization_type", "organization_id"], :name => "index_awards_on_organization_type_and_organization_id"
  add_index "awards", ["originating_sponsor_id"], :name => "index_awards_on_originating_sponsor_id"
  add_index "awards", ["person_id"], :name => "index_awards_on_person_id"
  add_index "awards", ["sponsor_id"], :name => "index_awards_on_sponsor_id"

  create_table "contact_lists", :force => true do |t|
    t.string   "name"
    t.integer  "organizational_unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_lists_contacts", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "contact_list_id"
  end

  add_index "contact_lists_contacts", ["contact_list_id", "contact_id"], :name => "contact_lists_contacts_idx"

  create_table "contacts", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company_name"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["email"], :name => "index_contacts_on_email"

  create_table "contacts_organizational_units", :id => false, :force => true do |t|
    t.integer "organizational_unit_id"
    t.integer "contact_id"
  end

  add_index "contacts_organizational_units", ["contact_id", "organizational_unit_id"], :name => "contacts_organizational_units_idx"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["name"], :name => "index_countries_on_name"

  create_table "ctsa_reports", :force => true do |t|
    t.integer  "created_by_id"
    t.boolean  "finalized"
    t.boolean  "has_errors"
    t.integer  "reporting_year"
    t.string   "grant_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ctsa_reports", ["created_by_id"], :name => "index_ctsa_reports_on_created_by_id"

  create_table "degree_types", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "degree_types", ["name"], :name => "index_degree_types_on_name"
  add_index "degree_types", ["type"], :name => "index_degree_types_on_type"

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "externalid"
    t.string   "entity_name"
    t.string   "school"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments", ["externalid"], :name => "index_departments_on_externalid"
  add_index "departments", ["name"], :name => "index_departments_on_name"

  create_table "dependencies", :force => true do |t|
    t.integer  "question_id"
    t.integer  "question_group_id"
    t.string   "rule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dependency_conditions", :force => true do |t|
    t.integer  "dependency_id"
    t.string   "rule_key"
    t.integer  "question_id"
    t.string   "operator"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ethnic_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ethnic_types", ["name"], :name => "index_ethnic_types_on_name"

  create_table "institution_positions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "institution_positions", ["name"], :name => "index_institution_positions_on_name"

  create_table "institution_positions_people", :id => false, :force => true do |t|
    t.integer "institution_position_id"
    t.integer "person_id"
  end

  add_index "institution_positions_people", ["institution_position_id", "person_id"], :name => "institution_positions_people_idx"

  create_table "organizational_units", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cc_pers_affiliate_identifier"
  end

  add_index "organizational_units", ["name"], :name => "index_organizational_units_on_name"
  add_index "organizational_units", ["parent_id"], :name => "index_organizational_units_on_parent_id"

  create_table "organizational_units_people", :id => false, :force => true do |t|
    t.integer "organizational_unit_id"
    t.integer "person_id"
  end

  add_index "organizational_units_people", ["organizational_unit_id", "person_id"], :name => "organizational_units_people_idx"

  create_table "organizations", :force => true do |t|
    t.string   "type"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["code"], :name => "index_organizations_on_code"
  add_index "organizations", ["name"], :name => "index_organizations_on_name"
  add_index "organizations", ["type"], :name => "index_organizations_on_type"

  create_table "participating_organizations", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.integer  "country_id"
    t.integer  "us_state_id"
    t.integer  "reporting_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "type"
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
    t.string   "personnelid"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.boolean  "edited_by_user"
    t.integer  "organizational_unit_id"
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
    t.string   "training_type"
    t.string   "trainee_status"
    t.boolean  "has_disability"
    t.string   "gender"
    t.string   "title"
    t.string   "fax"
    t.boolean  "edited"
    t.boolean  "imported"
    t.integer  "ctsa_reporting_years_mask"
  end

  add_index "people", ["country_id"], :name => "index_people_on_country_id"
  add_index "people", ["degree_type_one_id"], :name => "index_people_on_degree_type_one_id"
  add_index "people", ["degree_type_two_id"], :name => "index_people_on_degree_type_two_id"
  add_index "people", ["department_id"], :name => "index_people_on_department_id"
  add_index "people", ["employeeid"], :name => "index_people_on_employeeid"
  add_index "people", ["era_commons_username"], :name => "index_people_on_era_commons_username"
  add_index "people", ["ethnic_type_id"], :name => "index_people_on_ethnic_type_id"
  add_index "people", ["netid"], :name => "people_netid_idx", :unique => true
  add_index "people", ["organizational_unit_id"], :name => "index_people_on_organizational_unit_id"
  add_index "people", ["race_type_id"], :name => "index_people_on_race_type_id"
  add_index "people", ["specialty_id"], :name => "index_people_on_specialty_id"

  create_table "publications", :force => true do |t|
    t.string   "pmcid"
    t.string   "pmid"
    t.string   "nihms_number"
    t.date     "publication_date"
    t.integer  "person_id"
    t.text     "abstract"
    t.string   "title",                     :limit => 1000
    t.boolean  "nucats_assisted"
    t.boolean  "edited_by_user"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cited"
    t.string   "missing_pmcid_reason"
    t.integer  "ctsa_reporting_years_mask"
  end

  add_index "publications", ["person_id"], :name => "index_publications_on_person_id"

  create_table "question_groups", :force => true do |t|
    t.text     "text"
    t.text     "help_text"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.string   "display_type"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.integer  "survey_section_id"
    t.integer  "question_group_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.string   "pick"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "display_type"
    t.boolean  "is_mandatory"
    t.integer  "display_width"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "correct_answer_id"
  end

  create_table "race_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "race_types", ["name"], :name => "index_race_types_on_name"

  create_table "response_sets", :force => true do |t|
    t.integer  "user_id",         :limit => 8
    t.integer  "survey_id",       :limit => 8
    t.string   "access_code"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
    t.integer  "service_line_id"
  end

  add_index "response_sets", ["access_code"], :name => "response_sets_ac_idx", :unique => true

  create_table "responses", :force => true do |t|
    t.integer  "response_set_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "response_group"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "survey_section_id"
  end

  add_index "responses", ["survey_section_id"], :name => "index_responses_on_survey_section_id"

  create_table "service_lines", :force => true do |t|
    t.string   "name"
    t.integer  "organizational_unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "service_lines", ["name"], :name => "index_service_lines_on_name"

  create_table "services", :force => true do |t|
    t.integer  "service_line_id"
    t.integer  "person_id"
    t.integer  "created_by_id"
    t.date     "entered_on"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["created_by_id"], :name => "index_services_on_created_by_id"
  add_index "services", ["person_id"], :name => "index_services_on_person_id"
  add_index "services", ["service_line_id"], :name => "index_services_on_service_line_id"

  create_table "specialties", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "specialties", ["code"], :name => "index_specialties_on_code"
  add_index "specialties", ["name"], :name => "index_specialties_on_name"

  create_table "sponsors", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "sponsor_type_description"
    t.string   "sponsor_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sponsors", ["code"], :name => "index_sponsors_on_code"
  add_index "sponsors", ["name"], :name => "index_sponsors_on_name"

  create_table "survey_sections", :force => true do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.text     "description"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "custom_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "access_code"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.datetime "active_at"
    t.datetime "inactive_at"
    t.string   "css_url"
    t.string   "custom_class"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "display_order"
  end

  add_index "surveys", ["access_code"], :name => "surveys_ac_idx", :unique => true

  create_table "us_states", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "validation_conditions", :force => true do |t|
    t.integer  "validation_id"
    t.string   "rule_key"
    t.string   "operator"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "regexp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "validations", :force => true do |t|
    t.integer  "answer_id"
    t.string   "rule"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.text     "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
