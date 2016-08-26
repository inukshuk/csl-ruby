source 'https://rubygems.org'
gemspec

group :development, :test do
  gem 'rake', '~>10.0'
  gem 'rspec', '~>3.0'
  gem 'cucumber', '~>1.2'
end

group :debug do
  if RUBY_VERSION >= '2.0'
    gem 'byebug', :require => false, :platforms => :mri
  else
    gem 'debugger', :require => false, :platforms => :mri
  end

  gem 'ruby-debug', :require => false, :platforms => :jruby

  gem 'rubinius-debugger', :require => false, :platforms => :rbx
  gem 'rubinius-compiler', :require => false, :platforms => :rbx
end

group :optional do
  gem 'nokogiri', '~> 1.6'
end

group :extra do
  gem 'guard', '~>2.2'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'bond'
  gem 'diff-lcs'
  gem 'pry'
  gem 'rb-fsevent', '~>0.9', :platforms => :ruby
  gem 'yard', '~>0.8', :platforms => :mri
  gem 'redcarpet', '~>3.0', :platforms => :mri
end

group :coverage do
  gem 'coveralls', :require => false
  gem 'simplecov', '~>0.8', :require => false
  gem 'rubinius-coverage', :platform => :rbx
end

group :rbx do
  gem 'rubysl', '~>2.0', :platforms => :rbx
  gem 'racc', :platforms => :rbx
  gem 'json', '~>1.8', :platforms => :rbx
end

# vim: syntax=ruby
