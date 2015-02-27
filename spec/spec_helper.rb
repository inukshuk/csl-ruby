begin
  require 'simplecov'
  require 'coveralls' if ENV['CI']
rescue LoadError
  # ignore
end

begin
  case
  when RUBY_PLATFORM < 'java'
    require 'debug'
    Debugger.start
  when defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
    require 'rubinius/debugger'
  when defined?(RUBY_VERSION) && RUBY_VERSION < '2.0'
    require 'debugger'
  else
    require 'byebug'
  end
rescue LoadError
  # ignore
end

require 'rexml/document'
require 'nokogiri'

require 'csl'

module SilentWarnings
  require 'stringio'
  #
  # Adapted form silent_warnings gist by @avdi
  # https://gist.github.com/1170926
  #
  def silent_warnings
    original_stderr = $stderr
    $stderr = StringIO.new
    yield
  ensure
    $stderr = original_stderr
  end
end

RSpec.configure do |config|
  config.include(SilentWarnings)

  config.before :all do
    @style_root, @locale_root = CSL::Style.root, CSL::Locale.root

    CSL::Style.root  = File.expand_path('../fixtures/styles',  __FILE__)
    CSL::Locale.root = File.expand_path('../fixtures/locales', __FILE__)
  end

  config.after :all do
    CSL::Style.root, CSL::Locale.root = @style_root, @locale_root
  end
end
