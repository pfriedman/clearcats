Given /^a Person with a first name "(.*)" who was changed from "(.*)" and netid "([^"]*)"$/ do |current_first_name, previous_first_name, netid|
  person = Factory(:person, :netid => netid, :first_name => previous_first_name)
  person.first_name = current_first_name
  person.save!
end

Given /^an Award with a grant title "(.*)" which was changed from "(.*)" and budget_number "(.*)"$/ do |current_grant_title, previous_grant_title, budget_number|
  award = Factory(:award, :grant_title => previous_grant_title, :budget_number => budget_number)
  award.grant_title = current_grant_title
  award.save!
end

Given /^a Publication with a pmcid "(.*)" which was changed from "(.*)" and pmid "(.*)"$/ do |current_pmcid, previous_pmcid, pmid|
  pub = Factory(:publication, :pmcid => previous_pmcid, :pmid => pmid)
  pub.pmcid = current_pmcid
  pub.save!
end