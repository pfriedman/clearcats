require "haml"
class AuthenticationFailureHandler
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    status, headers, response = @app.call(env)
    
    if response.respond_to?(:status) and response.status == 403
      @user = env["bcsec"].user if env["bcsec"]
      
      # Render a HAML template using the HAML engine
      # http://haml-lang.com/docs/yardoc/Haml/Engine.html
      template = File.read(File.expand_path(File.join(File.dirname(__FILE__),"..", "app","views", "static", "authentication_failure.html.haml")))
      haml_engine = Haml::Engine.new(template)
      output = haml_engine.render(binding)
      
      [status, {"Content-Type" => "text/html"}, output]
    else
      [status, headers, response]
    end
  end

end