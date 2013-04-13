source 'https://rubygems.org'
gemspec

group :debug do
  gem 'ruby-debug', :platforms => [:mri_18, :jruby]
  gem 'debugger', :platforms => [:mri_19]
  gem 'debugger2', :platforms => [:mri_20]
end

group :optional do
  gem 'nokogiri', '~>1.5'
end

group :extra do
  gem 'simplecov', '~>0.6'

  gem 'guard', '~>1.2'
  gem 'guard-rspec', '~>1.1'
  gem 'guard-cucumber', '~>1.2'
  gem 'rb-fsevent', '~>0.9.1', :platforms => [:mri_19, :mri_20, :rbx]

  gem 'yard', '~>0.8', :platforms => [:mri_19, :mri_20]
  gem 'redcarpet', '~>2.1', :platforms => [:mri_19, :mri_20]
end

# vim: syntax=ruby