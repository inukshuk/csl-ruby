# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'csl/version'

EXCLUDES = %w{
  .coveralls.yml
  .travis.yml
  .csl.gemspec
}

Gem::Specification.new do |s|
  s.name        = 'csl'
  s.version     = CSL::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Sylvester Keil']
  s.email       = ['http://sylvester.keil.or.at']
  s.homepage    = 'https://github.com/inukshuk/csl-ruby'
  s.summary     = 'A Ruby CSL parser and library'
  s.description =
    """
		A Ruby parser and full API for the Citation Style Language (CSL),
		an open XML-based language to describe the formatting of citations
		and bibliographies.
		"""

  s.license     = 'AGPL-3.0'
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency('namae', ['~>0.7'])

  s.files        = `git ls-files`.split("\n") - EXCLUDES
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = []
  s.require_path = 'lib'

  s.has_rdoc      = 'yard'
end

# vim: syntax=ruby
