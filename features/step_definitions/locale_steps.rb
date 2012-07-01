Given /^the(?: following)? locale:?$/ do |string|
  @locale = CSL::Locale.load(string)
end

When /^I load the locale from the string$/ do |string|
  @locale = CSL::Locale.load(string)
end

When /^I ordinalize the number (\d+)(?: using the (long) form(?: and (feminine|masculine) gender))?$/ do |num, form, gender|
  @ordinal = @locale.ordinalize(num, :form => form, :gender => gender)
end

Then /^the ordinal should (?:be|equal) "([^"]*)"$/ do |ord|
  ord.should == @ordinal
end

When /^I ordinalize these numbers:?$/ do |table|
  @ordinals = table.rows.map do |row|
    num, form, gender = *row
    @locale.ordinalize(num, :form => form, :gender => gender)
  end
end

Then /^the ordinals should (?:be|equal):?$/ do |table|
  table.rows.should == @ordinals
end

Then /^the locale should should have (\d+) terms$/ do |num|
	@locale.terms.length.should == num.to_i
end

Then /^the (\w+[\?!]?) of the term "([^"]*)" should be "([^"]*)"$/ do |method, name, expected|
	@locale.terms.detect { |t| t.name == name }.send(method).should == expected
end