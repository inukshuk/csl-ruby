Given /^the(?: following)? locale:?$/ do |string|
  @csl = CSL::Locale.load(string)
end

When /^I load the locale from the string$/ do |string|
  @csl = CSL::Locale.load(string)
end

When /^I ordinalize the number (\d+)(?: using the (long) form(?: and (feminine|masculine) gender))?$/ do |num, form, gender|
  @ordinal = @locale.ordinalize(num, :form => form, :gender => gender)
end

Then /^the ordinal should (?:be|equal) "([^"]*)"$/ do |ord|
  @ordinal.should == ord
end

When /^I ordinalize these numbers:?$/ do |table|
  @ordinals = table.rows.map do |row|
    num, form, gender, number = *row
    @csl.ordinalize(num, :form => form, :gender => gender, :number => number)
  end
end

Then /^the ordinals should (?:be|equal):?$/ do |table|
  @ordinals.join(' ').should == table.rows.flatten.join(' ')
end

Then /^the locale should should have (\d+) terms$/ do |num|
	@csl.terms.length.should == num.to_i
end

Then /^the (\w+[\?!]?) of the term "([^"]*)" should be "([^"]*)"$/ do |method, name, expected|
	@csl.terms.detect { |t| t.name == name }.send(method).should == expected
end