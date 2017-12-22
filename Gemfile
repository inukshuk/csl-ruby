source 'https://rubygems.org'
gemspec

group :development, :test do
  gem 'rake'
  gem 'rspec'
  gem 'cucumber'
end

group :debug do
  gem 'byebug', require: false, platforms: :mri
  gem 'ruby-debug', require: false, platforms: :jruby
end

group :optional do
  gem 'nokogiri'
end

group :extra do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'bond'
  gem 'diff-lcs'
  gem 'pry'
  gem 'rb-fsevent', platforms: :ruby
  gem 'yard', platforms: :mri
  gem 'redcarpet', platforms: :mri
end

group :coverage do
  gem 'coveralls', require: false if ENV['CI']
  gem 'simplecov', require: false
end

# vim: syntax=ruby
