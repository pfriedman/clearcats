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

ActiveRecord::Schema.define(:version => 20100714190938) do

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
