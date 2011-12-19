
When /^I parse the CSL string$/ do |string|
  @node = CSL.parse string
end

Then /^(?:the )?(\w+[\?!]?) should be "([^"]*)"$/ do |name, expected|
  @node.send(name).to_s.should == expected
end

Then /^the (\w+) (\w+) should be "([^"]*)"$/ do |outer, inner, expected|
  @node.send(outer).send(inner).to_s.should == expected
end

Then /^the attribute "([^"]*)" should be "([^"]*)"$/ do |name, expected|
  @node[name.to_sym].should == expected
end

Then /^the node should have (\d+) (\w+)$/ do |length, name|
  @node.send(name).length.should == length.to_i
end

Then /^the (\w+) number (\d+) should have the attribute "([^"]*)" set to "([^"]*)"$/ do |name, offset, attribute, expected|
  @node.send("#{name}s")[offset.to_i - 1][attribute.to_sym].should == expected
end