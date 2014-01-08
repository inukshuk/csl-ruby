source 'https://rubygems.org'
gemspec

group :development, :test do
  gem 'rake', '~>10.0'
  gem 'rspec', '~>2.13'
  gem 'cucumber', '~>1.2'
end

group :debug do
  gem 'ruby-debug', :require => false, :platforms => [:jruby]
  gem 'debugger', :require => false, :platforms => [:mri]
  gem 'rubinius-debugger', :require => false, :platforms => :rbx
  gem 'rubinius-compiler', :require => false, :platforms => :rbx
end

group :optional do
  gem 'nokogiri', '~> 1.6'
end

group :extra do
  gem 'simplecov', '~>0.8'
  gem 'rubinius-coverage', :platforms => :rbx

  gem 'guard', '~>2.2'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'rb-fsevent', '~>0.9', :platforms => [:ruby]

  gem 'yard', '~>0.8', :platforms => [:mri]
  gem 'redcarpet', '~>3.0', :platforms => [:mri]
end

platform :rbx do
  gem 'rubysl', '~>2.0'
  gem 'json', '~>1.8'
end

# vim: syntax=ruby
