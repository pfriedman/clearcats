module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
      
    when /login/
      '/login'
      
    when /the edit service page/
      edit_service_path(Service.last)

    when /the edit service page for person "(.*)" and service line "(.*)"/
      edit_service_path(Service.first(:conditions => { :person => Person.find_by_netid($1), :service_line => ServiceLine.find_by_name($2) }))

    when /the services choose person page/
      choose_person_services_path
      
    when /the service choose person page/
      choose_person_service_path(Service.last)
      
    when /the service choose service line page/
      choose_service_line_service_path(Service.last)

    when /the service identified page/
      identified_service_path(Service.last)
      
    when /the service choose awards page/
      choose_awards_service_path(Service.last)

    when /the edit publication page for the "(.*)"/
      edit_publication_path(Publication.find_by_title($1))
      
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
