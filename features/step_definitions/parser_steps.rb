
When /^I parse the CSL string(?: in the (\w+) scope)?$/ do |scope, string|
  @csl = CSL.parse string, CSL.const_get(scope || 'Node')
end

Then /^(?:the )?(\w+[\?!]?) should be "([^"]*)"$/ do |name, expected|
  actual = @csl.send(name)
  actual = !!actual if expected =~ /^true|false$/
  expect(actual.to_s).to eq(expected)
end

Then /^the (\w+) (\w+) should be "([^"]*)"$/ do |outer, inner, expected|
  expect(@csl.send(outer).send(inner).to_s).to eq(expected)
end

Then /^the attribute "([^"]*)" should be "([^"]*)"$/ do |name, expected|
  expect(@csl[name.to_sym]).to eq(expected)
end

Then /^the node should have (\d+) (\w+)$/ do |length, name|
  expect(@csl.send(name).length).to eq(length.to_i)
end

Then /^the (\w+) number (\d+) should have the attribute "([^"]*)" set to "([^"]*)"$/ do |name, offset, attribute, expected|
  expect(@csl.send("#{name}s")[offset.to_i - 1][attribute.to_sym]).to eq(expected)
end

Then /^the (\w+) number (\d+) should( not)? be a (\w+)$/ do |name, offset, negate, predicate|
  expect(@csl.send("#{name}s")[offset.to_i - 1].send("#{predicate}?")).to eq(negate.nil?)
end

Then /^the (\w+) number (\d+)'s (\w+) should( not)? be "([^"]*)"$/ do |name, offset, method, negate, expected|
  actual = @csl.send("#{name}s")[offset.to_i - 1].send(method).to_s
  
  if negate.nil?
    expect(actual).to eq(expected)
  else
    expect(actual).not_to eq(expected)
  end
end
