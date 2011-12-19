
When /^I parse the CSL string$/ do |string|
  @node = CSL.parse string
end

Then /^the (\w+) should be "([^"]*)"$/ do |name, expected|
  @node.send(name).to_s.should == expected
end

Then /^the (\w+) (\w+) should be "([^"]*)"$/ do |outer, inner, expected|
  @node.send(outer).send(inner).to_s.should == expected
end
