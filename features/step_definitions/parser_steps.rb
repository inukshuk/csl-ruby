
When /^I parse the CSL string(?: in the (\w+) scope)?$/ do |scope, string|
  @csl = CSL.parse string, CSL.const_get(scope || 'Node')
end

Then /^(?:the )?(\w+[\?!]?) should be "([^"]*)"$/ do |name, expected|
  @csl.send(name).to_s.should == expected
end

Then /^the (\w+) (\w+) should be "([^"]*)"$/ do |outer, inner, expected|
  @csl.send(outer).send(inner).to_s.should == expected
end

Then /^the attribute "([^"]*)" should be "([^"]*)"$/ do |name, expected|
  @csl[name.to_sym].should == expected
end

Then /^the node should have (\d+) (\w+)$/ do |length, name|
  @csl.send(name).length.should == length.to_i
end

Then /^the (\w+) number (\d+) should have the attribute "([^"]*)" set to "([^"]*)"$/ do |name, offset, attribute, expected|
  @csl.send("#{name}s")[offset.to_i - 1][attribute.to_sym].should == expected
end

Then /^the (\w+) number (\d+) should( not)? be a (\w+)$/ do |name, offset, negate, predicate|
  @csl.send("#{name}s")[offset.to_i - 1].send("#{predicate}?").should == negate.nil?
end
