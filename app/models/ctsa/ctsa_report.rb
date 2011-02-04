# == Schema Information
# Schema version: 20101202161044
#
# Table name: ctsa_reports
#
#  id             :integer         not null, primary key
#  finalized      :boolean
#  has_errors     :boolean
#  reporting_year :integer
#  grant_number   :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  created_by     :string(255)
#  updated_by     :string(255)
#

require 'ctsa_xml_builders'
class CtsaReport < ActiveRecord::Base
  has_many :attachments, :as => :attachable
  accepts_nested_attributes_for :attachments, :allow_destroy => true
  
  # Creates the xml for the ctsa report
  def create_xml_report(directory)
    # TODO: check for valid ctsa report data
    file_path = "#{directory}/#{Time.now.to_i}.xml"
    doc = REXML::Document.new
    doc.add_element(ReportBuilder.new(grant_number, reporting_year, attachments))
    doc.write("",2)
    File.open(file_path, 'w') { |f| f.write(doc.to_s) }
    add_report_xml_to_attachments(file_path)
    file_path
  end
  
  def create_zip_file
    zip_file = Zippy.create "#{Rails.root}/tmp/ctsa_reports/ctsa.zip" do |zip|
      attachments.each do |doc|
        #TODO: set other document type extensions
        doc_name = (doc.name == "ctsa_report.xml") ? doc.name : "#{doc.data_file_name}"
        zip[doc_name] = File.open(doc.data.path)
      end
    end
    zip_file
  end

  private
   
    def add_report_xml_to_attachments(file_path)
      unless attachments.map { |a| a.name }.include?("ctsa_report.xml")
        file = File.open(file_path)
        attachment = ::Attachment.new(:name => "ctsa_report.xml", :reporting_year => self.reporting_year)
        paperclip  = Paperclip::Attachment.new(:data, attachment, {})
        paperclip.assign(file)
        attachment.save!
        paperclip.save
        self.attachments << attachment
        self.save
      end
    end

end
