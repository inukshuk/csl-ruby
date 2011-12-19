When /^I load the locale from the string$/ do |string|
  @result = CSL::Locale.load(string)
end