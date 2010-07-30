Given /^a publication with a title "(.*)"$/ do |title|
  Factory(:publication, :title => title)
end

# When /^I visit the edit publication page for the "([^\"]*)"$/ do |title|
#   visit edit_publication_url(Publication.find_by_title(title))
# end