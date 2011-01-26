require 'rexml/document'
require 'rexml/element'
# include REXML 

# Pulled from TurboCATS
#
# The ReportBuilder builds an XML document for the XML schema definition
# available at http://aprsis.ncrr.nih.gov/xml/ctsa_progress_report.xsd.
# Given the grant number, investigators, trainees, publications, organizations, and attachments
# the ReportBuilder builds the XML required by the NIH.
# 
# <sis:Progress_Report 
#     xsi:schemaLocation="http://sis.ncrr.nih.gov http://aprsis.ncrr.nih.gov/xml/ctsa_progress_report.xsd"
#     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
#     xmlns:sis="http://sis.ncrr.nih.gov">
# ...
# </sis:Progress_Report>

class ReportBuilder < REXML::Element
  def initialize(grant_number, reporting_year)
    super "sis:Progress_Report"
    add_attribute("xmlns:sis", "http://sis.ncrr.nih.gov")
    add_attribute("xsi:schemaLocation", "http://sis.ncrr.nih.gov http://aprsis.ncrr.nih.gov/xml/ctsa_progress_report.xsd")
    add_attribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
    
    trainees      = Person.all_trainees.for_reporting_year(reporting_year)
    investigators = Person.all_investigators.for_reporting_year(reporting_year)
    
    add_element(GrantBuilder.new(grant_number))
    add_element(RosterBuilder.new(investigators, trainees, reporting_year))
    add_element(PublicationsBuilder.new(Publication.all_for_reporting_year(reporting_year)))
    add_element(ResourceProjectionsBuilder.new)
    add_element(ProgramDescriptionBuilder.new(ParticipatingOrganization.all_for_reporting_year(reporting_year)))
    add_element(CharacteristicsBuilder.new(trainees))
  end
end

#
# Grant Helper methods - creates the GrantInfo node with the 6 digit grant number
#   
# <sis:Grant_Info>
#   <sis:Six_Digit_Grant_Number> - 123456 - </sis:Six_Digit_Grant_Number>
# </sis:Grant_Info>

class GrantBuilder < REXML::Element
  def initialize(grant_number)
    super "sis:Grant_Info"
    add_element("sis:Six_Digit_Grant_Number").add_text(grant_number)
  end
end

#
# Roster helper methods
#
# <sis:Roster>
# ...
# </sis:Roster>

class RosterBuilder < REXML::Element
  def initialize(investigators, trainees, reporting_year)
    super "sis:Roster"
    investigators.each do |investigator|
      add_element(InvestigatorBuilder.new(investigator, reporting_year))
    end
    add_element(TrainingBuilder.new(trainees))
  end
end


# <sis:Investigator>
#   <sis:Commons_Username>  - era_commons_username - </sis:Commons_Username>
#   <sis:Area_of_Expertise> - specialty.code - </sis:Area_of_Expertise>
# </sis:Investigator>

class InvestigatorBuilder < REXML::Element
  def initialize(investigator, reporting_year)
    super 'sis:Investigator'
    add_element("sis:Commons_Username").add_text(investigator.commons_username.upcase.strip)
    add_element("sis:Area_of_Expertise").add_text(investigator.area_of_expertise_code.to_s)
    add_non_phs_awards_list(investigator, reporting_year)
    add_phs_awards_list(investigator, reporting_year)
  end
  
  def add_non_phs_awards_list(investigator, reporting_year)
    awards = investigator.awards.all_for_reporting_year(reporting_year)
    awards.each do |award|
      next unless award.organization.type == "NonPhsOrganization"
      add_non_phs_award(award)
    end
  end
  
  def add_non_phs_award(award)
    add_element(NonPhsAwardBuilder.new(award))
  end
  
  def add_phs_awards_list(investigator, reporting_year)
    awards = investigator.awards.all_for_reporting_year(reporting_year)
    awards.each do |award|
      next unless award.organization.type == "PhsOrganization"
      add_phs_award(award)
    end
  end
  
  def add_phs_award(award)
    add_element(PhsAwardBuilder.new(award))
  end
  
end


# <sis:Federal_Non_PHS_Funding> 
#   <sis:PI_Name> + investigator.ctsa_name + </sis:PI_Name> 
#   <sis:Organization> + non_phs_award.organization.code + </sis:Organization> 
#   <sis:Grant_Contract_Number> + non_phs_award.grant_number + </sis:Grant_Contract_Number> 
#   <sis:Grant_Title> + non_phs_award.grant_title + </sis:Grant_Title> 
#   <sis:Total_Dollars> + non_phs_award.grant_amount + </sis:Total_Dollars> 
# <sis:Federal_Non_PHS_Funding> 

class NonPhsAwardBuilder <  REXML::Element
  
  def initialize(award)
    super "sis:Federal_Non_PHS_Funding"
    add_element("sis:PI_Name").add_text(award.person.ctsa_name)
    add_element("sis:Organization").add_text(award.organization.code)
    add_element("sis:Grant_Contract_Number").add_text(award.grant_number)
    add_element("sis:Grant_Title").add_text(award.grant_title[0,50])
    add_element("sis:Total_Dollars").add_text(award.grant_amount.to_i.to_s)
  end
  
end

# <sis:Federal_PHS_Funding> 
#   <sis:Organization> + phs_award.organization.code + </sis:Organization> 
#   <sis:Activity_Code> + phs_award.activity_code.code + </sis:Activity_Code> 
#   <sis:Six_Digit_Grant_Number> + phs_award.grant_number.to_s + </sis:Six_Digit_Grant_Number> 
# <sis:Federal_PHS_Funding> 
class PhsAwardBuilder <  REXML::Element
  
  def initialize(award)
    super "sis:Federal_PHS_Funding"
    add_element("sis:Organization").add_text(award.organization.code)
    add_element("sis:Activity_Code").add_text(award.activity_code.code)
    add_element("sis:Six_Digit_Grant_Number").add_text(award.grant_number)
  end
  
end

# <sis:Training>
# ...
# </sis:Training>

class TrainingBuilder < REXML::Element
  def initialize(trainees)
    super "sis:Training"
    (Person.scholars + Person.other_careers + Person.trainees).each do |trainee|
      add_element(TraineeBuilder.new(trainee))
    end
  end
end

#   <sis:Scholar> | <sis:OtherCareerDevelopment> | <sis:Trainee>
#     <sis:Commons_Username> - era_commons_username - </sis:Commons_Username>
#     <sis:Degree_Sought_1> </sis:Degree_Sought_1>
#     <sis:Degree_Sought_2> </sis:Degree_Sought_2>
#     <sis:Area_of_Training> </sis:Area_of_Training>
#     <sis:Date_of_Appointment> </sis:Date_of_Appointment>
#     <sis:End_Date> </sis:End_Date>
#     <sis:Mentor_Commons_Username> </sis:Mentor_Commons_Username>
#   </sis:Scholar>
class TraineeBuilder < REXML::Element
  
  def initialize(trainee)
    type = ""
    trainee.training_type.each("_") do |sec|
      type += sec.capitalize
    end
    
    super "sis:" + type
    add_element("sis:Commons_Username").add_text(trainee.commons_username.upcase.strip)
    
    if trainee.degree_1 and !trainee.degree_1.blank?
      add_element("sis:Degree_Sought_1").add_text(trainee.degree_1)
    end
    
    if trainee.degree_2 and !trainee.degree_2.blank?
      add_element("sis:Degree_Sought_2").add_text(trainee.degree_2)
    end
    
    add_element("sis:Area_of_Training").add_text(trainee.area_of_expertise_code.to_s)
    add_element("sis:Date_of_Appointment").add_text(trainee.date_of_appointment.strftime('%Y-%m-%d'))
    add_element("sis:End_Date").add_text(trainee.end_date.strftime('%Y-%m-%d'))
    add_element("sis:Mentor_Commons_Username").add_text(trainee.mentor_commons_username.upcase.strip)
  end

end


#
# publications methods
#
# <sis:Publications>
# ...
# </sis:Publications>
class PublicationsBuilder < REXML::Element
  
  def initialize(publications)
    super "sis:Publications"
    processed_pubmed_ids =[]
    publications.each do |publication|
      if not processed_pubmed_ids.detect{ |id| id == publication.pubmed_id }
        add_element(PublicationBuilder.new(publication))
        processed_pubmed_ids.push(publication.pubmed_id)
      end
    end
  end
  
end

#   <sis:Publication>
#     <sis:Cited> </sis:Cited>
#     <sis:PubMed_ID> </sis:PubMed_ID>
#     <sis:Missing_PCMCID_Reason> </sis:Missing_PCMCID_Reason> (optional)
#   </sis:Publication>
class PublicationBuilder < REXML::Element
 
  def initialize(publication)
    @publication = publication
    super "sis:Publication"
    cited = publication.cited ? 'Y' : 'N'
    add_element("sis:Cited").add_text(cited)
    add_element("sis:PubMed_ID").add_text(@publication.pubmed_id.to_s)
    unless @publication.missing_pmcid_reason.blank?
      add_element("sis:Missing_PMCID_Reason").add_text(@publication.missing_pmcid_reason.to_s)
    end
  end
  
end

# TODO: determine if this needs to be changed or should be hard-coded numbers
#
# <sis:Resource_Projections>
#   <sis:Percent_Clinical_Trials>30</sis:Percent_Clinical_Trials>
#   <sis:Percent_Pediatrics>15</sis:Percent_Pediatrics>
#   <sis:Percent_AIDS>0</sis:Percent_AIDS>
# </sis:Resource_Projections>
class ResourceProjectionsBuilder < REXML::Element
  
  def initialize()
    super "sis:Resource_Projections"
    add_element("sis:Percent_Clinical_Trials").add_text("30")
    add_element("sis:Percent_Pediatrics").add_text("15")
    add_element("sis:Percent_AIDS").add_text("0")
  end
  
end

#
# Program Description Helpers
#
# <sis:Program_Description>
#   <sis:Participating_Organization_or_Institution>
#     <sis:Participant_Name></sis:Participant_Name>
#     <sis:Participant_City></sis:Participant_City>
#     <sis:Participant_US_State></sis:Participant_US_State>
#   </sis:Participating_Organization_or_Institution>
# </sis:Program_Description>
class ProgramDescriptionBuilder < REXML::Element
  
  def initialize(orgs)
    super "sis:Program_Description"
    orgs.each do |org|
      add_element(ParticipatingOrganizationsBuilder.new(org))
    end
  end
  
end

class ParticipatingOrganizationsBuilder < REXML::Element
  
  def initialize(org)
    super "sis:Participating_Organization_or_Institution"
    if org
      add_element("sis:Participant_Name").add_text(org.name) 
      add_element("sis:Participant_City").add_text(org.city)
      add_element("sis:Participant_US_State").add_text(org.us_state.to_s) if org.us_state
      add_element("sis:Participant_Non_US_Country").add_text(org.country.to_s) if org.country and org.us_state.blank?
    end
  end
  
end


#
# characteristics Helpers
#
# <sis:Characteristics>
# ...
# </sis:Characteristics>
class CharacteristicsBuilder < REXML::Element
  def initialize(trainees)
    super "sis:Characteristics"
    Person::TRAINEE_STATUSES.each  do |status|
      Person::TRAINING_TYPES.each do |type|
        add_element(CharacteristicBuilder.new(trainees, nodify(type), nodify(status)))
      end
    end
  end
  
  def nodify(name)
    name.titleize.gsub(' ', '_')
  end
end

# <sis:#{status}__#{type[0,16]}_Characts>
# ...
# </sis:#{status}__#{type[0,16]}_Characts>
class CharacteristicBuilder < REXML::Element
  # trainees - a collection of trainees (person)
  # type     - Trainee, Scholar, Other_Career_Development
  # status   - Applicant, Appointed
  def initialize(trainees, type, status)
    super "sis:#{status}_#{type[0,16]}_Characts"
    @trainees = trainees.select {|trainee| trainee.trainee_status.downcase == status.downcase and trainee.training_type.downcase == type.downcase}
    add_element(EntireEnrollmentBuilder.new(@trainees, status, type))
    add_element(HispanicEnrollmentBuilder.new(@trainees, status, type))
    if status == "Appointed"
      add_element(DisabilityBuilder.new(@trainees))
      add_element(DisadvantagedBuilder.new(@trainees))
    end
  end
end


# <sis:Entire_Enrollment>
# ...
# </sis:Entire_Enrollment>
class EntireEnrollmentBuilder < REXML::Element
  def initialize(trainees, status, type)
    super "sis:Entire_Enrollment"
    add_element(EthnicCategoriesBuilder.new(trainees, status))
    add_element(RacialCategoriesBuilder.new(trainees, status))
  end    
end


# <sis:Ethnic_Category>
# ...
# </sis:Ethnic_Category>
class EthnicCategoriesBuilder < REXML::Element  
  def initialize (trainees, status)
    super "sis:Ethnic_Category"
    ["HispanicOrLatino", "Non-Hispanic", "Unknown"].each do |category|
      #non_nil_trainees = trainees.select{|trainee| not trainee.ethnic_category.nil?}
      @trainees = trainees.select {|trainee| not trainee.ethnic_category.nil? and trainee.ethnic_category.downcase == category.downcase}
      add_element(EthnicCategoryBuilder.new(@trainees, status, category))
    end
  end
end


# <sis:#{category}>
# ...
# </sis:#{category}>
class EthnicCategoryBuilder < REXML::Element
  
  # category - HispanicOrLatino, Non-Hispanic, Unknown
  # status   - appointed, applicant
  def initialize(trainees, status, category)
    super "sis:#{category}"
    @trainees = trainees.select {|trainee| not trainee.ethnic_category.nil? and trainee.ethnic_category.downcase == category.downcase}
    if status.downcase == "appointed"
      ["Females", "Males", "Not_Reported"].each do |gender|
        add_element(GenderCountBuilder.new(@trainees, gender))
      end
    elsif status.downcase == "applicant"
      ["Accepted", "Applied", "Interviewed"].each do |status|
        add_element(ApplicantStatusBuilder.new(@trainees, status))
      end
    end
  end
end


# <sis:Hispanic_Enrollment>
# ...
# </sis:Hispanic_Enrollment>
class HispanicEnrollmentBuilder < REXML::Element
  def initialize(trainees, status, type)
    super "sis:Hispanic_Enrollment"
      @trainees = trainees.select {|trainee| not trainee.ethnic_category.nil? and trainee.ethnic_category.downcase == "HispanicOrLatino".downcase}
      @races = ["American_Indian_or_Alaska_Native", "Asian", "Native_Hawaiian_or_Other_Pacific_Islander", 
                "Black_Or_African_American", "White", "More_Than_One_Race", "Unknown"]
      @races.each do |race|
        add_element(RacialCategoryBuilder.new(@trainees, race, status))
      end       
  end
end


# <sis:Racial_Category>
# ...
# </sis:Racial_Category>
class RacialCategoriesBuilder < REXML::Element
  
  def initialize(trainees, status)
    super "sis:Racial_Category"
    @races = ["American_Indian_or_Alaska_Native", "Asian", "Native_Hawaiian_or_Other_Pacific_Islander", 
              "Black_Or_African_American", "White", "More_Than_One_Race", "Unknown"]
    @races.each do |race|
      add_element(RacialCategoryBuilder.new(trainees, race, status))
    end    
  end 
end


# <sis:#{race}>
# ...
# </sis:#{race}>
class RacialCategoryBuilder < REXML::Element
  
  # race - American_Indian_or_Alaska_Native, Asian, Native_Hawaiian_or_Other_Pacific_Islander,
  #        Black_Or_African_American, White, More_Than_One_Race, Unknown
  def initialize(trainees, race, status)
    super "sis:#{race}"
    
    @trainees = trainees.select {|trainee| not trainee.racial_category.nil? and trainee.racial_category.downcase == race.downcase}
    
    if status == "Applicant"
      ["Accepted", "Applied", "Interviewed"].each do |applicant_status|
        add_element(ApplicantStatusBuilder.new(@trainees, applicant_status))
      end
    else
      ["Females", "Males", "Not_Reported"].each do |gender|
        add_element(GenderCountBuilder.new(@trainees, gender))
      end
    end
  end
end


# <sis:#{status}>
# ...
# </sis:#{status}>
class ApplicantStatusBuilder < REXML::Element
  
  # status - Applied, Accepted, Interviewed
  def initialize(trainees, status)
    super "sis:#{status}"
    case status
    when "Applied"
      @trainees = trainees.select {|trainee| trainee.applied == true}
    when "Accepted"
      @trainees = trainees.select {|trainee| trainee.accepted == true}
    when "Interviewed"
      @trainees = trainees.select {|trainee| trainee.interviewed == true}
    end
    ["Females", "Males", "Not_Reported"].each do |gender|
      add_element(GenderCountBuilder.new(@trainees, gender))
    end
  end
end


# <sis:#{gender}>
# ...
# </sis:#{gender}>
class GenderCountBuilder < REXML::Element
  
  # gender - Females, Males, Not_Reported
  def initialize(trainees, gender)
    super "sis:#{gender}"
    gender = gender.sub(/s/,'')
    @trainees = trainees.select {|trainee| not trainee.gender.nil? and trainee.gender.downcase == gender.downcase}
    add_text(@trainees.size.to_s)
  end
end


# <sis:Number_with_Disabilities>
# ...
# </sis:Number_with_Disabilities>
class DisabilityBuilder < REXML::Element
  def initialize(trainees)
    super "sis:Number_with_Disabilities"
    @trainees = trainees.select {|trainee| trainee.has_disability == true}
    add_text(@trainees.size.to_s)
  end
end


# <sis:Number_from_Disadvantaged_Backgrounds>
# ...
# </sis:Number_from_Disadvantaged_Backgrounds>
class DisadvantagedBuilder <REXML::Element
  def initialize(trainees)
    super "sis:Number_from_Disadvantaged_Backgrounds"
    @trainees = trainees.select {|trainee| trainee.disadvantaged_background == true}
    add_text(@trainees.size.to_s)
  end
end
