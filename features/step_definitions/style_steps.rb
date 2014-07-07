
When /^I load the style from the string$/ do |string|
  @csl = CSL::Style.load string
end

Then /^the locale (\d+) should should have (\d+) terms?$/ do |locale, term|
	expect(@csl.locales[locale.to_i - 1].terms.length).to eq(term.to_i)
end

Then /^the locale (\d+) (\w+\??) should be "([^"]*)"$/ do |locale, method, expected|
  expect(@csl.locales[locale.to_i - 1].send(method).to_s).to eq(expected)
end

Then /^the style should have (\d+) contributors$/ do |num|
  expect(@csl.info.contributors.length).to eq(num.to_i)
end
