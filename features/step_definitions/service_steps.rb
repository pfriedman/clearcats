Given /^an organizational_unit "(.*)" with these service_lines:$/ do |org_unit_name, table|
  org_unit = OrganizationalUnit.create!(:name => org_unit_name, :abbreviation => org_unit_name)
  table.hashes.each do |sl|
    svc_line = ServiceLine.create!(:name => sl[:name])
    OrganizationalService.create!(:service_line => svc_line, :organizational_unit => org_unit)
  end
end

Given /^a person having the name "([^"]*)" and the username "([^"]*)"$/ do |name, netid|
  Factory(:person, :first_name => name.split[0], :last_name => name.split[1], :netid => netid)
end
