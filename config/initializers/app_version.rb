version_filename = "#{Rails.root}/config/app_version.yml"
if File.exists?(version_filename)
  APP_VERSION = YAML.load_file(version_filename)
else
  puts "Warning: application version file is missing. (#{version_filename})"
end