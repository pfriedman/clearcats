module ClearCats
  module ExternalServices
    class Resource
      def initialize(service, identifier)
        services = YAML.load_file(SERVICES_CONFIG_FILE)
        host = services[service][:host][ENV['RAILS_ENV']]
        path = services[service][:path][identifier]
        @resource = URI.join(host, path)
      end

      def to_s
        @resource.to_s
      end
    end
  end
end
