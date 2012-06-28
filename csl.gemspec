# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'csl/version'

Gem::Specification.new do |s|
  s.name        = 'csl'
  s.version     = CSL::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Sylvester Keil']
  s.email       = ['http://sylvester.keil.or.at']
  s.homepage    = 'https://github.com/inukshuk/csl-ruby'
  s.summary     = 'A Ruby CSL parser and library'
  s.description = <<-END.gsub(/\s+/, ' ')
		A Ruby parser and library for the Citation Style Language (CSL), an open
		XML-based language to describe the formatting of citations and
		bibliographies.
		END
  s.license     = 'FreeBSD'
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.add_development_dependency('cucumber', ['~>1.1'])
  s.add_development_dependency('rspec', ['~>2.7'])
  s.add_development_dependency('rake', ['~>0.9'])

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = []
  s.require_path = 'lib'

  s.rdoc_options      = %w{--line-numbers --inline-source --title "CSL" --main README.md --webcvs=https://github.com/inukshuk/csl-ruby/tree/master/}
  s.extra_rdoc_files  = %w{README.md}
  
end

# vim: syntax=ruby