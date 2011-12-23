
When /^I load the style from the string$/ do |string|
  @result = CSL::Style.load string
end

Then /^the locale (\d+) should should have (\d+) terms?$/ do |locale, term|
	@result.locales[locale.to_i - 1].terms.length.should == term.to_i
end

Then /^the locale (\d+) (\w+\??) should be "([^"]*)"$/ do |locale, method, expected|
  @result.locales[locale.to_i - 1].send(method).to_s.should == expected
end

Then /^the style should have (\d+) contributors$/ do |num|
  @result.info.contributors.length.should == num.to_i
end
