source :rubygems
gemspec

group :debug do
  gem 'ruby-debug', :platforms => [:mri_18, :jruby]
  gem 'debugger', :platforms => [:mri_19]
end

group :optional do
  gem 'nokogiri', '~>1.5'
end

group :development do
  gem 'simplecov', '~>0.6'
  gem 'guard', '~>1.2'
  gem 'guard-rspec', '~>1.1'
end

# vim: syntax=ruby