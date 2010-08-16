require 'rexml/document'
include REXML 

# Pulled from TurboCATS
#
# The ReportMessageHelper builds an XML document for the XML schema definition
# available at http://aprsis.ncrr.nih.gov/xml/ctsa_progress_report.xsd.
# Given the grant number, investigators, trainees, publications, organizations, and attachments
# the ReportMessageHelper builds the XML required by the NIH.
# 
# <sis:Progress_Report 
#     xsi:schemaLocation="http://sis.ncrr.nih.gov http://aprsis.ncrr.nih.gov/xml/ctsa_progress_report.xsd"
#     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
#     xmlns:sis="http://sis.ncrr.nih.gov">
# ...
# </sis:Progress_Report>

class ReportMessageHelper < REXML::Element
  def initialize(grant_number, investigators, trainees)
    super "sis:Progress_Report"
    add_attribute("xmlns:sis", "http://sis.ncrr.nih.gov")
    add_attribute("xsi:schemaLocation", "http://sis.ncrr.nih.gov http://aprsis.ncrr.nih.gov/xml/ctsa_progress_report.xsd")
    add_attribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
    add_element(GrantMessageHelper.new(grant_number))
    add_element(RosterMessageHelper.new(investigators, trainees))
  end
end

#
# Grant Helper methods - creates the GrantInfo node with the 6 digit grant number
#   
# <sis:Grant_Info>
#   <sis:Six_Digit_Grant_Number> - 123456 - </sis:Six_Digit_Grant_Number>
# </sis:Grant_Info>

class GrantMessageHelper < REXML::Element
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

class RosterMessageHelper < REXML::Element
  def initialize(investigators, trainees)
    super "sis:Roster"
    investigators.each do |investigator|
      add_element(InvestigatorMessageHelper.new(investigator))
    end
    add_element(TrainingMessageHelper.new(trainees))
  end
end


# <sis:Investigator>
#   <sis:Commons_Username>  - era_commons_username - </sis:Commons_Username>
#   <sis:Area_of_Expertise> - specialty.code - </sis:Area_of_Expertise>
# </sis:Investigator>

class InvestigatorMessageHelper < REXML::Element
  def initialize(investigator)
    super 'sis:Investigator'
    add_element("sis:Commons_Username").add_text(investigator.commons_username.upcase.strip)
    add_element("sis:Area_of_Expertise").add_text(investigator.area_of_expertise_code.to_s)
  end
end


# <sis:Training>
# ...
# </sis:Training>

class TrainingMessageHelper < REXML::Element
  def initialize(trainees)
    super "sis:Training"
    (Person.scholars + Person.other_careers + Person.trainees).each do |trainee|
      add_element(TraineeMessageHelper.new(trainee))
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
class TraineeMessageHelper < REXML::Element
  
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