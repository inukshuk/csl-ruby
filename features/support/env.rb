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
  else
    require 'byebug'
  end
rescue LoadError
  # ignore
end

require 'csl'
