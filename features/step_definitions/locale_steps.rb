When /^I load the locale from the string$/ do |string|
  @result = CSL::Locale.load(string)
end

Then /^the locale should should have (\d+) terms$/ do |num|
	@result.terms.length.should == num.to_i
end

Then /^the (\w+[\?!]?) of the term "([^"]*)" should be "([^"]*)"$/ do |method, name, expected|
	@result.terms.detect { |t| t.name == name }.send(method).should == expected
end