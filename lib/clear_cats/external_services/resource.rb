module ClearCats
  module ExternalServices
    class Resource
      def initialize(service, identifier)
        services = YAML.load_file(SERVICES_CONFIG_FILE)[ENV['RAILS_ENV']]
        host = services[service][:host]
        path = services[service][:path][identifier]
        path = "/" if path.blank?
        @resource = URI.join(host, path)
      end

      def to_s
        @resource.to_s
      end
    end
  end
end
