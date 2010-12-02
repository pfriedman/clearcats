class AddBcAuditColumns < ActiveRecord::Migration
  def self.up
    add_column :services, :updated_by, :string
    add_column :ctsa_reports, :updated_by, :string
    
    add_column :activity_codes, :created_by, :string
    add_column :activity_codes, :updated_by, :string

    add_column :activity_types, :created_by, :string
    add_column :activity_types, :updated_by, :string
    
    add_column :approvals, :created_by, :string
    add_column :approvals, :updated_by, :string

    add_column :attachments, :created_by, :string
    add_column :attachments, :updated_by, :string

    add_column :award_details, :created_by, :string
    add_column :award_details, :updated_by, :string

    add_column :awards, :created_by, :string
    add_column :awards, :updated_by, :string

    add_column :contact_lists, :created_by, :string
    add_column :contact_lists, :updated_by, :string

    add_column :contacts, :created_by, :string
    add_column :contacts, :updated_by, :string

    add_column :countries, :created_by, :string
    add_column :countries, :updated_by, :string
    
    add_column :degree_types, :created_by, :string
    add_column :degree_types, :updated_by, :string
    
    add_column :departments, :created_by, :string
    add_column :departments, :updated_by, :string
    
    add_column :dependencies, :created_by, :string
    add_column :dependencies, :updated_by, :string
    
    add_column :dependency_conditions, :created_by, :string
    add_column :dependency_conditions, :updated_by, :string
    
    add_column :ethnic_types, :created_by, :string
    add_column :ethnic_types, :updated_by, :string
    
    add_column :institution_positions, :created_by, :string
    add_column :institution_positions, :updated_by, :string
    
    add_column :organizational_units, :created_by, :string
    add_column :organizational_units, :updated_by, :string
    
    add_column :organizations, :created_by, :string
    add_column :organizations, :updated_by, :string
    
    add_column :people, :created_by, :string
    add_column :people, :updated_by, :string
    
    add_column :publications, :created_by, :string
    add_column :publications, :updated_by, :string
    
    add_column :question_groups, :created_by, :string
    add_column :question_groups, :updated_by, :string
    
    add_column :questions, :created_by, :string
    add_column :questions, :updated_by, :string
    
    add_column :race_types, :created_by, :string
    add_column :race_types, :updated_by, :string
    
    add_column :response_sets, :created_by, :string
    add_column :response_sets, :updated_by, :string
    
    add_column :responses, :created_by, :string
    add_column :responses, :updated_by, :string
    
    add_column :service_lines, :created_by, :string
    add_column :service_lines, :updated_by, :string
    
    add_column :specialties, :created_by, :string
    add_column :specialties, :updated_by, :string
    
    add_column :sponsors, :created_by, :string
    add_column :sponsors, :updated_by, :string
    
    add_column :survey_sections, :created_by, :string
    add_column :survey_sections, :updated_by, :string
    
    add_column :surveys, :created_by, :string
    add_column :surveys, :updated_by, :string
    
    add_column :us_states, :created_by, :string
    add_column :us_states, :updated_by, :string
    
    add_column :validation_conditions, :created_by, :string
    add_column :validation_conditions, :updated_by, :string
    
    add_column :validations, :created_by, :string
    add_column :validations, :updated_by, :string
    
  end

  def self.down
    remove_column :services, :updated_by
    remove_column :ctsa_reports, :updated_by

    remove_column :activity_codes, :created_by
    remove_column :activity_codes, :updated_by

    remove_column :activity_types, :created_by
    remove_column :activity_types, :updated_by
    
    remove_column :approvals, :created_by
    remove_column :approvals, :updated_by

    remove_column :attachments, :created_by
    remove_column :attachments, :updated_by

    remove_column :award_details, :created_by
    remove_column :award_details, :updated_by

    remove_column :awards, :created_by
    remove_column :awards, :updated_by

    remove_column :contact_lists, :created_by
    remove_column :contact_lists, :updated_by

    remove_column :contacts, :created_by
    remove_column :contacts, :updated_by

    remove_column :countries, :created_by
    remove_column :countries, :updated_by
    
    remove_column :degree_types, :created_by
    remove_column :degree_types, :updated_by
    
    remove_column :departments, :created_by
    remove_column :departments, :updated_by
    
    remove_column :dependencies, :created_by
    remove_column :dependencies, :updated_by
    
    remove_column :dependency_conditions, :created_by
    remove_column :dependency_conditions, :updated_by
    
    remove_column :ethnic_types, :created_by
    remove_column :ethnic_types, :updated_by
    
    remove_column :institution_positions, :created_by
    remove_column :institution_positions, :updated_by
    
    remove_column :organizational_units, :created_by
    remove_column :organizational_units, :updated_by
    
    remove_column :organizations, :created_by
    remove_column :organizations, :updated_by
    
    remove_column :people, :created_by
    remove_column :people, :updated_by
    
    remove_column :publications, :created_by
    remove_column :publications, :updated_by
    
    remove_column :question_groups, :created_by
    remove_column :question_groups, :updated_by
    
    remove_column :questions, :created_by
    remove_column :questions, :updated_by
    
    remove_column :race_types, :created_by
    remove_column :race_types, :updated_by
    
    remove_column :response_sets, :created_by
    remove_column :response_sets, :updated_by
    
    remove_column :responses, :created_by
    remove_column :responses, :updated_by
    
    remove_column :service_lines, :created_by
    remove_column :service_lines, :updated_by
    
    remove_column :specialties, :created_by
    remove_column :specialties, :updated_by
    
    remove_column :sponsors, :created_by
    remove_column :sponsors, :updated_by
    
    remove_column :survey_sections, :created_by
    remove_column :survey_sections, :updated_by
    
    remove_column :surveys, :created_by
    remove_column :surveys, :updated_by
    
    remove_column :us_states, :created_by
    remove_column :us_states, :updated_by
    
    remove_column :validation_conditions, :created_by
    remove_column :validation_conditions, :updated_by
    
    remove_column :validations, :created_by
    remove_column :validations, :updated_by

  end
end