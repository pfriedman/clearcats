require 'nokogiri'

class ProtocolReader
  
  def initialize(file_path)
    puts file_path
    @file_path = file_path
    raise "Please supply a valid document path - was given #{@file_path}" if !File.exists?(@file_path)
    @xml = Nokogiri::XML(File.open(@file_path))
  end
  
  def extract_emails
    emails = []
    
    @xml.xpath("//email").each do |node| 
      email = node.text.to_s unless node.text.to_s.blank?
      emails << email unless emails.include?(email)
    end
    
    emails
  end
  
end