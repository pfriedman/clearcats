Given /^an organizational_unit "(.*)" with these service_lines:$/ do |org_unit_name, table|
  org_unit = OrganizationalUnit.create!(:name => org_unit_name, :abbreviation => org_unit_name, :cc_pers_affiliate_identifier => org_unit_name)
  table.hashes.each do |sl|
    svc_line = ServiceLine.create!(:name => sl[:name], :organizational_unit => org_unit)
  end
end

Given /^an organizational_unit "(.*)" with the service_line "(.*)"$/ do |org_unit_name, service_line_name|
  org_unit = OrganizationalUnit.create!(:name => org_unit_name, :abbreviation => org_unit_name, :cc_pers_affiliate_identifier => org_unit_name)
  svc_line = ServiceLine.create!(:name => service_line_name, :organizational_unit => org_unit)
end

Given /^a person having the name "([^"]*)" and the username "([^"]*)"$/ do |name, netid|
  Factory(:person, :first_name => name.split[0], :last_name => name.split[1], :netid => netid)
end

Given /^a service "([^"]*)" for person "([^"]*)" having been initiated by the logged in user$/ do |service_line_name, netid|
  Factory(:service, :person => Person.find_by_netid(netid), :service_line => ServiceLine.find_by_name(service_line_name), :created_by => @current_user)
end