module VersionExportable
  
  def export_versions
    keys = ["when", "who"] + get_attribute_names
    csv_string = FasterCSV.generate do |csv|
      add_headers(csv, keys)
      add_version_values(csv)
      add_object_values(csv)
    end
    csv_string
  end
  
  private
  
    def add_headers(csv, keys)
      csv << keys.map {|key| key.titleize}
    end
  
    def add_version_values(csv)
      self.versions.each do |v|
        next if v.object.nil?
        vals = []
        vals << v.created_at.to_s(:db)
        vals << v.whodunnit
        get_attribute_names.each { |a| vals << get_value(v, a) }
        csv << vals
      end
    end
  
    def add_object_values(csv)
      vals = ["Current Record", ""]
      get_attribute_names.each { |a| vals << get_value(self, a) }
      csv << vals
    end
  
    def get_attribute_names
      self.attribute_names - ["id"]
    end
    
    def get_value(obj, attribute)
      value = obj[attribute]
      if attribute[-3,3] == "_id" and !value.blank?
        value = attribute.titleize.gsub(/ /,'').constantize.find(value).to_s
      end
      value
    end
  
end