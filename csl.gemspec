require_relative 'lib/csl/version'

Gem::Specification.new do |s|
  s.name        = 'csl'
  s.version     = CSL::VERSION
  s.authors     = ['Sylvester Keil']
  s.email       = ['sylvester@keil.or.at']
  s.homepage    = 'https://github.com/inukshuk/csl-ruby'
  s.licenses    = ['BSD-2-Clause']
  s.summary     = 'A Ruby CSL parser and library'
  s.description = <<~EOS
    A Ruby parser and full API for the Citation Style Language (CSL),
    an open XML-based language to describe the formatting of citations
    and bibliographies.
  EOS

  s.metadata = {
    'source_code_uri' => 'https://github.com/inukshuk/csl-ruby',
    'bug_tracker_uri' => 'https://github.com/inukshuk/csl-ruby/issues',
    'rubygems_mfa_required' => 'true'
  }

  s.required_ruby_version = '>= 3.1'
  s.add_dependency('namae', ['~> 1.2'])
  s.add_dependency('rexml', '~> 3.0')
  s.add_dependency('forwardable', '~> 1.3')
  s.add_dependency('open-uri', '< 1.0')
  s.add_dependency('singleton', '< 1.0')
  s.add_dependency('set', '~> 1.1')
  s.add_dependency('time', '< 1.0')

  s.files = Dir[
    'lib/**/*.rb',
    'vendor/schema/*.rng',
    'BSDL',
    'README.md'
  ]
end
